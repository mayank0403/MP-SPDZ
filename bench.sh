#!/bin/bash

set -e

if [ $# -lt 11 ]
then
    echo "Script expects Records_Begin Records_End BucketSize Conditions Threads ROLE SEVER_0_IP LAN/WAN SINGLE_SERVER<S/M> (Multi)T()hread)/R(oundopt)/B(oth) (m)al/(s)h"
    exit
fi

echo "Records_Begin = 1 << $1"
echo "Records_End = 1 << $2"
echo "BucketSize or Comparison Bitwidth = 1 << $3"
echo "Predicate Count or Condition Count = $4"
echo "Threads = $5"
echo "Party #$6"
echo "Server_0 IP Address $7"
echo "Network Configuration $8"
echo "Single Server or Multi $9"
echo "Multitheaded / Roundopt / Both = ${10}"
echo "Malicious / Semi-honest = ${11}"
echo $(date)

if [ "${10}" = "B" ]
then
    echo "Not implemented both"
    exit
fi

#touch bench_results.txt
#echo "Network Configuration $3" >> bench_results.txt
#echo $(date) >> bench_results.txt

if [ "$8" = "WAN" ]
then
    echo "TODO: Script will run wan.sh here"
    ./wan.sh $9
    ping -c 5 localhost
    ping -c 5 "$7"
fi

if [ "$9" = "S" ]
then
    echo "Running all 3 parties on single machine"
    for i in $(seq $1 2 $2)
    do
        echo "Working on iteration $i"
        
        if [ "${10}" = "T" ]
        then
            echo "Running SH Multithreaded file ..."
            Scripts/ring.sh "dorydb_mthread_""$i""_""$3""_""$4""_$5"
            
            echo "Running Mal Multithreaded file ..."
            Scripts/ps-rep-ring.sh "dorydb_mthread_mal_""$i""_""$3""_""$4""_$5"
        fi

        if [ "${10}" = "R" ]
        then
            echo "Running SH Round-optimal file ..."
            Scripts/ring.sh "dorydb_roundopt_""$i""_""$3""_""$4""_$5"
            
            echo "Running Mal Round-optimal file ..."
            Scripts/ps-rep-ring.sh "dorydb_roundopt_mal_""$i""_""$3""_""$4""_$5"
        fi
    done
fi

if [ "$9" = "M" ]
then
    echo "Running all 3 parties on different machines"
    for i in $(seq $1 2 $2)
    do
        echo "Working on iteration $i"
        
        if [ "${10}" = "T" ]
        then
            if [ "${11}" = "s" ]
            then
                echo "Running SH Multithreaded file ..."
                ./replicated-ring-party.x -S 80 -p "$6" -h "$7" "dorydb_mthread_""$i""_""$3""_""$4""_$5" -pn 32000 
            fi
            
            if [ "${11}" = "m" ]
            then
                echo "Running Mal Multithreaded file ..."
                ./ps-rep-ring-party.x -S 80 -p "$6" -h "$7" "dorydb_mthread_mal_""$i""_""$3""_""$4""_$5" -pn 32000 
            fi
        fi

        if [ "${10}" = "R" ]
        then
            echo "Running SH Round-optimal file ..."
            ./replicated-ring-party.x -S 80 -p "$6" -h "$7" "dorydb_roundopt_""$i""_""$3""_""$4""_$5" -pn 32000 
            
            echo "Running Mal Round-optimal file ..."
            ./ps-rep-ring-party.x -S 80 -p "$6" -h "$7" "dorydb_roundopt_mal_""$i""_""$3""_""$4""_$5" -pn 32000 
        fi
    done
fi

if [ "$8" = "WAN" ]
then
    ./wan-reset.sh $9
    ping -c 5 localhost
    ping -c 5 "$7"
fi

