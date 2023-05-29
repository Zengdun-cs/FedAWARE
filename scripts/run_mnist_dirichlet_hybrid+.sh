#!/bin/bash


python main.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 1998 -partition dirichlet -dir 0.1  -alpha 0.5 -startup 1 -agnostic 1 & \

python baselines/fedavg.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 1998  -partition dirichlet -dir 0.1  -agnostic 1 & \

python baselines/fedavgm.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 1998  -partition dirichlet -dir 0.1  -agnostic 1 -fedm_beta 0.7 & \

python baselines/fedprox.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 1998  -partition dirichlet -dir 0.1  -mu 0.1 -agnostic 1 & \

python baselines/scaffold.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 1998  -partition dirichlet -dir 0.1  -agnostic 1 & \

wait

python baselines/fednova.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 1998  -partition dirichlet -dir 0.1  -agnostic 1 & \

python baselines/fedopt.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 0.01 -dataset mnist -dseed 2023 -seed 1998  -partition dirichlet -dir 0.1  -option yogi -beta1 0.9 -beta2 0.99 -tau 0.0001 -agnostic 1 & \

python main.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 37 -partition dirichlet -dir 0.1  -alpha 0.5 -startup 1 -agnostic 1 & \

python baselines/fedavg.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 37  -partition dirichlet -dir 0.1  -agnostic 1 & \

wait

python baselines/fedavgm.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 37  -partition dirichlet -dir 0.1  -agnostic 1 -fedm_beta 0.7 & \

python baselines/fedprox.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 37  -partition dirichlet -dir 0.1  -mu 0.1 -agnostic 1 & 

python baselines/scaffold.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 37  -partition dirichlet -dir 0.1  -agnostic 1 & \

python baselines/fednova.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 37  -partition dirichlet -dir 0.1  -agnostic 1 & \

python baselines/fedopt.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 0.01 -dataset mnist -dseed 2023 -seed 37  -partition dirichlet -dir 0.1  -option yogi -beta1 0.9 -beta2 0.99 -tau 0.0001 -agnostic 1 & \

wait

python main.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 73 -partition dirichlet -dir 0.1  -alpha 0.5 -startup 1 -agnostic 1 & \

python baselines/fedavg.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 73  -partition dirichlet -dir 0.1  -agnostic 1 & \

python baselines/fedavgm.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 73  -partition dirichlet -dir 0.1  -agnostic 1 -fedm_beta 0.7 & \

wait 

python baselines/fedprox.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 73  -partition dirichlet -dir 0.1  -mu 0.1 -agnostic 1 & \

python baselines/scaffold.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 73  -partition dirichlet -dir 0.1  -agnostic 1 & \

python baselines/fednova.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 1 -dataset mnist -dseed 2023 -seed 73  -partition dirichlet -dir 0.1  -agnostic 1 & \

python baselines/fedopt.py -num_clients 100 -com_round 500 -sample_ratio 0.1 -lr 0.01 -glr 0.01 -dataset mnist -dseed 2023 -seed 73  -partition dirichlet -dir 0.1  -option yogi -beta1 0.9 -beta2 0.99 -tau 0.0001 -agnostic 1 & \

wait

