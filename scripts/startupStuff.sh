#!/bin/bash

# avoid vmware player occur error: not vmci
sudo modprobe -a vmw_vmci vmmon vmnet
