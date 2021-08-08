#!/bin/bash

echo "MOD = -DRING_SIZE=32" >> CONFIG.mine

echo "Set MP-SPDZ bitwidth of 32"
echo "Recompiling VMs"

make clean
make -j replicated-ring-party.x
make -j ps-rep-ring-party.x

echo "Recompiled"

