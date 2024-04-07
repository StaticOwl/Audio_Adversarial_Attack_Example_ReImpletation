from datetime import datetime as dt
import os
import json
import sys
import subprocess

output_path = "outputs/"+dt.now().strftime("%Y%m%d_%H%M%S")

if not os.path.exists(output_path):
    os.makedirs(output_path)
    # ./run.sh run --lr 10 --in sample.wav --target "example" --out adversarial.wav
    
input_files = [f for f in os.listdir('inputs/') if os.path.isfile(os.path.join('inputs/', f))]
    
with open('target_setter.json', 'r') as f:
    target_dict = json.load(f)
    additional_args = sys.argv[1:]
     
    for i, input_file in enumerate(input_files):
        output = os.path.join(output_path, "adv_"+input_file)
        args = ["python", "attack.py", 
                "--in", "inputs/"+input_file, 
                "--outprefix", output, 
                "--target", target_dict[input_file]] + additional_args
        
        result = subprocess.run(args)
        
        if result.returncode !=0:
            print("Error at audio {}".format(input_file))
            print("Stack: ", result.stderr)
        else:
            print("Attack successful on {}! Evaluating....".format(input_file))
            print("Original Audio Deepspeech output")
            args1 = ["deepspeech", "models/output_graph.pb", input_file, "models/alphabet.txt"]
            result = subprocess.run(args1)
                
            print("Adversarial Audio Deepspeech output")
            args2 = ["deepspeech", "models/output_graph.pb", "{}0.wav".format(output), "models/alphabet.txt"]
            result = subprocess.run(args2)
            
            if result.returncode !=0:
                print("Error at audio {}".format(input_file))
                print("Stack: ", result.stderr)
                
    try:
        os.rmdir(output_path)
    except OSError:
        print("Successfully Generated Adversarial Examples")
    
    


