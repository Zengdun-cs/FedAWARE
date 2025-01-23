# FedAWARE

 Code for paper "[On the Power of Adaptive Weighted Aggregation in Heterogeneous Federated Learning and Beyond](https://arxiv.org/abs/2310.02702)".


## Dependencies

 `pip install -r requirement.txt`

## Run

Plesee see the scripts in ```exp_scripts```.

Here is an example:
```
python [fedaware or baselines/fedxxx.py].py -num_clients 100 \
                    -com_round 500 \
                    -sample_ratio 0.1 \
                    -batch_size 64 \
                    -epochs 3 \
                    -lr 0.01 \
                    -glr 1 \
                    -dseed 37 [data partition random seed] \
                    -seed 1998 [running random seed] \
                    -partition [pathological/dirichlet] \
                    -dataset [mnist\fmnist/cifar10/agnews] \
                    -alpha 0.5 [hyperparameters]\
                    -startup 1 \
                    -agnostic [0/1] \
                    -preprocess 1 [dataset preprocesssing] \
                    -projection [0/1] [using Fedaware extension]
```

For Agnews task, please run ```python agnews_dataset.py``` to preprocess Agnews dataset. And, download pythia model from https://huggingface.co/EleutherAI/pythia-70m.

Note:
see utils.py FedAWARE_Projector class for our implementation details.
Please cite our paper if you found the code useful.

```
@misc{zeng2024poweradaptiveweightedaggregation,
      title={On the Power of Adaptive Weighted Aggregation in Heterogeneous Federated Learning and Beyond}, 
      author={Dun Zeng and Zenglin Xu and Shiyu Liu and Yu Pan and Qifan Wang and Xiaoying Tang},
      year={2024},
      eprint={2310.02702},
      archivePrefix={arXiv},
      primaryClass={cs.LG},
      url={https://arxiv.org/abs/2310.02702}, 
}
```
