#!/bin/bash

wandb_key="$1"  # First argument is the Wandb key
wandb_username="$2"  # Second argument is the Wandb username

# Set other variables as needed
python_script="/content/Federated-Learning-Group_0/src/federated.py"
data_dir="/content/drive/MyDrive/MLDL/shakespeare/data"
checkpoint_path="/content/drive/MyDrive/MLDL/shakespeare/checkpoints"
logfile_base="/content/drive/MyDrive/MLDL/shakespeare/logs/federated_shakespeare_100_noniid_uniform"
metrics_dir="/content/drive/MyDrive/MLDL/shakespeare/metrics"

# Check if GPU is available (using nvidia-smi command to check)
if nvidia-smi &> /dev/null; then
    gpu_arg="--gpu 0"
else
    gpu_arg=""
fi

# Loop over the combinations of j and nc
for j in 4 8 16
do
    name="federated_shakespeare_100_noniid_uniform_j=${j}_nc=${nc}"
    logfile="${logfile_base}_j=${j}_nc=${nc}.log"
    
    # Base command
    CMD="python3 $python_script \
        --dataset shakespeare \
        --model lstm \
        --epochs 200 \
        --checkpoint_path $checkpoint_path \
        --data_dir $data_dir \
        --lr 1 \
        --print_every 1 \
        --local_ep $j \
        --participation 1 \
        --logfile $logfile \
        --metrics_dir $metrics_dir"
    
    # Add GPU parameter if GPU is available
    if [ -n "$gpu_arg" ]; then
        CMD="$CMD $gpu_arg"
    fi

    # Add wandb parameters if they are provided
    if [ -n "$wandb_key" ] && [ -n "$wandb_username" ]; then
        CMD="$CMD --wandb_key $wandb_key \
            --wandb_username $wandb_username \
            --wandb_project Federated_Learning \
            --wandb_run_name $name"
    fi

    # Execute the command
    echo "Executing: $CMD"
    eval $CMD
done