# Audio_Adversarial_Attack_Example_ReImpletation

This project is inspired by the works of Nicholas Carlini on the Implementation of creating Adversarial Attack Sample on DeepSpeech.

Link to the original paper : https://arxiv.org/abs/1801.01944

Instruction for Original Implementation can be found [here](orig_impl/readme.md). However, running this code can be a bit painful.

I have worked towards a somewhat better implementation.

This project runs on CUDA 8.0, CUDNN 6 and Python3.5. It is advised to use a virtual environment for running this code (preferrably conda).
CUDA 8.0 -> https://developer.nvidia.com/cuda-toolkit-archive (Use the run file to install it, and then install the patch for 8.0.61)
CUDNN 6 -> https://developer.nvidia.com/rdp/cudnn-archive

To Install dependencies and Download the required dataset and model, run the following command:

```bash
./run.sh install gpu
```
or you can run this if you don't have gpu or CUDA installed:
```bash
./run.sh install cpu
```

To run the attack, run the following commands:

```bash
git clone
cd Audio_Adversarial_Attack_Example_ReImpletation
./run.sh run --lr 10 --in sample.wav --target "example" --out adversarial.wav
```

The following parameters are available for the attack:
```bash
help : Show this help message and exit
--lr : Learning Rate
--in : Input File
--target : Targeted Phrase
--out : Output File
--iterations : Number of iterations
```

There are some more parameters that can be used, but they are not recommended to be used unless you know what you are doing.



Will update the readme as I go through more.

TODO:

Check do we have to RM everything, then install deepspeech and build the checkpoints from again?