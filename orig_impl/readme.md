This is the code corresponding to the paper
"Audio Adversarial Examples: Targeted Attacks on Speech-to-Text"
Nicholas Carlini and David Wagner
https://arxiv.org/abs/1801.01944

To generate adversarial examples for your own files, follow the below process
and modify the arguments to attack,py. Ensure that the file is sampled at
16KHz and uses signed 16-bit ints as the data type. You may want to modify
the number of iterations that the attack algorithm is allowed to run.


Instructions for basic use:

1. Install the dependencies

pip3 install numpy==1.14.0 scipy==1.0.0 pydub==0.23.0 protobuf==3.5.1 pandas==0.22.0 python_speech_features==0.5
pip3 install tensorflow-gpu==1.8.0

2. Clone the Mozilla DeepSpeech repository into a folder called DeepSpeech:

git clone https://github.com/mozilla/DeepSpeech.git

2b. Checkout the correct version of the code:

(cd DeepSpeech; git checkout tags/v0.1.1)

3. Download the DeepSpeech model

wget https://github.com/mozilla/DeepSpeech/releases/download/v0.1.0/deepspeech-0.1.0-models.tar.gz
tar -xzf deepspeech-0.1.0-models.tar.gz

4. Verify that you have a file models/output_graph.pb, its MD5 sum should be
08a9e6e8dc450007a0df0a37956bc795.

5. Convert the .pb to a TensorFlow checkpoint file

python3 make_checkpoint.py

6. Generate adversarial examples

python3 attack.py --lr 10 --in sample.wav --target "example" --out adversarial.wav

7. (optional) Install the deepseech utility:

pip3 install deepspeech-gpu==0.1.1

8. Classify the generated phrase

deepspeech models/output_graph.pb adversarial.wav models/alphabet.txt


---

WARNING: THE CODE TO HOOK INTO DEEPSPEECH IS UGLY. This means I require a
very specific version of DeepSpeech (0.1.1) and TensorFlow (1.8.0) using
python 3.5. I can't promise it won't set your computer on fire if you use
any other versioning setup. (In particular, it WILL NOT work with
DeepSpeech 0.2.0+, and WILL NOT work with TensorFlow 1.10+.)

