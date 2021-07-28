#!/bin/bash

echo "MOD = -DRING_SIZE=88" >> CONFIG.mine

echo "Set MP-SPDZ bitwidth of 88"
echo "Recompiling VMs"

make clean
make -j replicated-ring-party.x
make -j ps-rep-ring-party.x

echo "Recompiled"

