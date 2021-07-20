#!/bin/bash

bwlimit=1mbit
delay=50ms

sudo tc qdisc del dev lo root
sudo tc qdisc add dev lo root netem rate $bwlimit delay $delay
echo rate $bwlimit delay $delay

