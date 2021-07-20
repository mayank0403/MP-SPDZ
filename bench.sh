#!/bin/bash

set -e

if [ $# -lt 7 ]
then
    #echo "Script expects ROLE SEVER_0_IP LAN/WAN Records BucketSize Conditions Threads"
    echo "Script expects ROLE SEVER_0_IP LAN/WAN Records BucketSize Conditions Threads"
    exit
fi

echo "Party #$1"
echo "Server_0 IP Address $2"
echo "Network Configuration $3"
echo "Records = 1 << $4"
echo "BucketSize or Comparison Bitwidth = 1 << $5"
echo "Predicate Count or Condition Count = $6"
echo "Threads = $7"

#touch bench_results.txt
#echo "Network Configuration $3" >> bench_results.txt
#echo $(date) >> bench_results.txt

if [ "$3" = "WAN" ]
then
    echo "TODO: Script will run wan.sh here"
fi

for i in $(seq 4 2 16)
do
    echo "Working on iteration $i"
    echo "Multithreaded file ..."
    python3 generate_file.py Programs/Source/dorydb_mthread_template.mpc Programs/Source/dorydb_mthread_12_8_5_8.mpc 16 8 5 8
    echo "Round-optimal file ..."
done

