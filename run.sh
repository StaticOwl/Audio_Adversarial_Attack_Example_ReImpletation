#!/bin/bash

# Function to install DeepSpeech and its dependencies

help() {
    echo "Usage: $0 <install|run>"
}
install_deepspeech() {
    local type="$1"

    echo "Starting installation..."
    echo "Type: $type"
    echo "Installing Python dependencies..."
    pip install -r requirements || { echo "Error: Failed to install basic dependencies"; exit 1; }
    pip install -r requirements-$type || { echo "Error: Failed to install $type dependencies"; exit 1; }

    echo "Step 1: Cloning the Mozilla DeepSpeech repository..."
    git clone https://github.com/mozilla/DeepSpeech.git || { echo "Error: Failed to clone the DeepSpeech repository"; exit 1; }

    echo "Step 2: Checking out the correct version of the DeepSpeech..."
    git config --global --add safe.directory $pwd/DeepSpeech
    (cd DeepSpeech && git checkout tags/"$deepspeech_version") || { echo "Error: Failed to checkout the correct version of the code"; exit 1; }

    echo "Step 3: Downloading the DeepSpeech model..."
    cd ..
    wget https://github.com/mozilla/DeepSpeech/releases/download/"$model_version"/deepspeech-"$model_version"-models.tar.gz || { echo "Error: Failed to download the DeepSpeech model"; exit 1; }
    tar -xzf deepspeech-"$model_version"-models.tar.gz || { echo "Error: Failed to extract the DeepSpeech model"; exit 1; }

    echo "Step 4: Verifying the model file..."
    expected_md5="08a9e6e8dc450007a0df0a37956bc795"
    actual_md5=$(md5sum models/output_graph.pb | awk '{print $1}')
    if [ "$actual_md5" != "$expected_md5" ]; then
        echo "Error: Model file verification failed. Expected MD5: $expected_md5, Actual MD5: $actual_md5"
        exit 1
    fi
    echo "Model file verified successfully."

    echo "Installation completed successfully."
}

# Function to run the attack script
run_attack() {
    local adversarial_input=""
    local type="$1"
    shift
    echo "Type: $type"

    # Look for --out in the command line arguments
    for (( i=1; i<=$#; i++ )); do
        if [[ "${!i}" == "--out" && $((i+1)) -le $# ]]; then
            adversarial_input="${@:i+1:1}"
            break
        fi
    done
    if [[ -z "$adversarial_input" && $type = "single" ]]; then
        echo "Error: Output File not found."
        exit 1
    fi
    echo "Step 1: Converting the .pb to a TensorFlow checkpoint file..."
    python3 make_checkpoint.py || { echo "Error: Failed to convert .pb to TensorFlow checkpoint file"; exit 1; }
    
    echo "Step 2: Generating adversarial examples..."
    if [[ $type = "multi" ]]; then
        python3 multi.py "$@" || { echo "Error: Failed to generate adversarial examples"; exit 1; }
    else
        python3 attack.py "$@" || { echo "Error: Failed to generate adversarial examples"; exit 1; }

        echo "Attack completed successfully."

        echo "Step 3: Running the evaluation script..."
        deepspeech models/output_graph.pb $adversarial_input models/alphabet.txt
    fi

}

# Check the number of arguments
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <install|run>"
    exit 1
fi

# Parse the command
command=$1
shift

case $command in
    install)
        if [ "$#" -lt 1 ]; then
            echo "Usage: $0 install gpu|cpu"
            exit 1
        fi
        install_deepspeech "$@"
        ;;
    run)
        run_attack "$@"
        ;;
    help)
        help
        ;;
    *)
        echo "Unknown command: $command. Usage: $0 <install|run>"
        exit 1
        ;;
esac