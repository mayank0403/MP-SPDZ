#!/bin/bash

bwlimit=10000mbit
delay=7ms

sudo tc qdisc del dev lo root
sudo tc qdisc add dev lo root netem rate $bwlimit delay $delay
echo rate $bwlimit delay $delay
