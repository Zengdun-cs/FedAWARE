import numpy as np
import json
import os
import argparse

import torch
from fedlab.utils.aggregator import Aggregators
from fedlab.utils.serialization import SerializationTool
from fedlab.utils.functional import evaluate, get_best_gpu

from fedlab.contrib.algorithm.basic_server import SyncServerHandler
from fedlab.utils.functional import evaluate, setup_seed
from fedlab.contrib.algorithm.fedavg import FedAvgSerialClientTrainer

import time

from mode import FedAvgSerialClientTrainer, UniformSampler, solver

from torch.utils.tensorboard import SummaryWriter
from min_norm_solvers import MinNormSolver, gradient_normalizers
from settings import get_settings

METHOD = "FedMGDA+"

class FedMGDAServerHandler(SyncServerHandler):
    def setup_optim(self, sampler, args):  
        self.n = self.num_clients
        self.num_to_sample = int(self.sample_ratio*self.n)
        self.round_clients = int(self.sample_ratio*self.n)
        self.sampler = sampler

        self.args = args
        self.lr = args.glr
        self.k = args.k
        self.solver = MinNormSolver
    
    @property
    def num_clients_per_round(self):
        return self.round_clients
           
    def sample_clients(self, k):
        clients = self.sampler.sample(k)
        self.round_clients = len(clients)
        assert self.num_clients_per_round == len(clients)
        return clients
        
    def global_update(self, buffer):
        gradient_list = [torch.sub(self.model_parameters, ele[0]) for ele in buffer]

        # MGDA+
        norms = np.array([torch.norm(grad, p=2, dim=0).item() for grad in gradient_list])
        normlized_gradients = [grad/n for grad, n in zip(gradient_list, norms)]
        sol, val = self.solver.find_min_norm_element_FW(normlized_gradients)
        print("GDA {}".format(val))
        assert val > 1e-5
        estimates = Aggregators.fedavg_aggregate(normlized_gradients, sol)

        serialized_parameters = self.model_parameters - self.lr*estimates
        SerializationTool.deserialize_model(self._model, serialized_parameters)

def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument('-num_clients', type=int)
    parser.add_argument('-com_round', type=int)
    parser.add_argument('-sample_ratio', type=float)

    # local solver
    parser.add_argument('-batch_size', type=int)
    parser.add_argument('-epochs', type=int)
    parser.add_argument('-lr', type=float)
    parser.add_argument('-glr', type=float)

    # data & reproduction
    parser.add_argument('-dataset', type=str, default="synthetic")
    parser.add_argument('-partition', type=str, default="dir") # dir, path
    parser.add_argument('-preprocess', type=bool, default=False)
    parser.add_argument('-seed', type=int, default=0) # run seed
    parser.add_argument('-dseed', type=int, default=0) # data seed

    # setting
    parser.add_argument('-a', type=float, default=0.0)
    parser.add_argument('-b', type=float, default=0.0)
    parser.add_argument('-dir', type=float, default=0.1)

    # mgda, fedavg, mgda+
    parser.add_argument('-method', type=str, default="fedavg")

    return parser.parse_args()

args = parse_args()

setup_seed(args.seed)
args.k = int(args.num_clients*args.sample_ratio)

# format
dataset = args.dataset
if args.dataset == "synthetic":
    dataset = "synthetic_{}_{}".format(args.a, args.b)

run_time = time.strftime("%m-%d-%H:%M")
base_dir = "logs/"
dir = "./{}/{}/DataSeed{}_RunSeed{}_NUM{}_BS{}_LR{}_EP{}_K{}_T{}/Setting_{}".format(base_dir, dataset, args.dseed, args.seed, args.num_clients, args.batch_size, args.lr, args.epochs, args.k, args.com_round, METHOD)
log = "{}".format(run_time)

path = os.path.join(dir, log)
writer = SummaryWriter(path)
json.dump(vars(args), open(os.path.join(path, "config.json"), "w"))

model, dataset, weights, gen_test_loader = get_settings(args)
args.weights = weights

# trainer
trainer = FedAvgSerialClientTrainer(model, args.num_clients, cuda=True)
trainer.setup_optim(args.epochs, args.batch_size, args.lr)
trainer.setup_dataset(dataset)

# server-sampler
handler = FedMGDAServerHandler(model=model,
                        global_round=args.com_round,
                        sample_ratio=args.sample_ratio)
handler.num_clients = trainer.num_clients
sampler = UniformSampler(args.num_clients)
handler.setup_optim(sampler, args)

t = 0
while handler.if_stop is False:
    print("running..")
    # server side
    broadcast = handler.downlink_package
    sampled_clients = handler.sample_clients(args.k)

    # client side
    train_loss, train_acc = trainer.local_process(broadcast, sampled_clients)
    full_info = trainer.uplink_package
    
    for pack in full_info:
        handler.load(pack)

    t += 1
    tloss, tacc = evaluate(handler._model, nn.CrossEntropyLoss(), gen_test_loader)
    
    writer.add_scalar('Train/loss/{}'.format(args.dataset), train_loss.avg, t)
    writer.add_scalar('Train/accuracy/{}'.format(args.dataset), train_acc.avg, t)

    writer.add_scalar('Test/loss/{}'.format(args.dataset), tloss, t)
    writer.add_scalar('Test/accuracy/{}'.format(args.dataset), tacc, t)

    print("Round {}, Loss {:.4f}, Accuracy: {:.4f}, Generalization: {:.4f}-{:.4f}".format(t, train_loss.avg,  train_acc.avg, tacc, tloss))