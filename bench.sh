#!/bin/bash

set -e

if [ $# -lt 3 ]
then
    echo "Script expects ROLE SEVER_0_IP LAN/WAN"
    exit
fi

echo "Party #$1"
echo "Server_0 IP Address $2"
echo "Network Configuration $3"

touch bench_results.txt
echo "Network Configuration $3" >> bench_results.txt
echo $(date) >> bench_results.txt

for i in {10..16}
do
    echo $i
done
