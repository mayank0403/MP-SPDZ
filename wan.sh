#!/bin/bash

bwlimit=80000mbit
delay=7ms

if [ $# -lt 1 ]
then
    echo "Script expects network interface"
    exit
fi

if [ "$1" = "S" ]
then
    sudo tc qdisc del dev lo root
    sudo tc qdisc add dev lo root netem rate $bwlimit delay $delay
fi

if [ "$1" = "M" ]
then
    sudo tc qdisc del dev ens3 root
    sudo tc qdisc add dev ens3 root netem rate $bwlimit delay $delay
fi

echo rate $bwlimit delay $delay
