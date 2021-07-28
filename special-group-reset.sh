#!/bin/bash

head -n -1 CONFIG.mine > special_group_temp.txt
mv special_group_temp.txt CONFIG.mine

echo "Set back MP-SPDZ bitwidth to default options of 32, 64, 72, 128"
