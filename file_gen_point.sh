#!/bin/bash

set -e

if [ $# -lt 6 ]
then
    echo "Script expects Records_Begin Records_End BucketSize Conditions Threads (Multi)T()hread)/R(oundopt)/B(oth)"
    exit
fi

echo "Records_Begin = 1 << $1"
echo "Records_End = 1 << $2"
echo "BucketSize or Comparison Bitwidth = 1 << $3"
echo "Predicate Count or Condition Count = $4"
echo "Threads = $5"
echo "Multitheaded / Roundopt / Both = $6"

if [ "$6" = "B" ]
then
    echo "Not implemented both"
    exit
fi

for i in $(seq $1 2 $2)
do
    echo "Working on iteration $i"
    
    if [ "$6" = "T" ]
    then
        echo "Generating Multithreaded file ..."
        python3 generate_file.py "Programs/Source/dorydb_point_mthread_template.mpc" "Programs/Source/dorydb_point_mthread_""$i""_""$3""_""$4""_$5"".mpc" "$i" "$3" "$4" "$5"
        
        echo "Compiling SH Multithreaded file ..."
        ./compile.py -Z 3 -R 128 "dorydb_point_mthread_""$i""_""$3""_""$4""_$5"".mpc"
        
        echo "Compiling Mal Multithreaded file ..."
        cp "Programs/Source/dorydb_point_mthread_""$i""_""$3""_""$4""_$5"".mpc" "Programs/Source/dorydb_point_mthread_mal_""$i""_""$3""_""$4""_$5"".mpc"
        ./compile.py -Z 3 -R 72 "dorydb_point_mthread_mal_""$i""_""$3""_""$4""_$5"".mpc"
    fi

    if [ "$6" = "R" ]
    then
        echo "Generating Round-optimal file ..."
        python3 generate_file.py "Programs/Source/dorydb_point_roundopt_template.mpc" "Programs/Source/dorydb_point_roundopt_""$i""_""$3""_""$4""_$5"".mpc" "$i" "$3" "$4" "$5"
        
        echo "Compiling SH Round-optimal file ..."
        ./compile.py -Z 3 -R 128 "dorydb_point_roundopt_""$i""_""$3""_""$4""_$5"".mpc"
        
        echo "Compiling Mal Round-optimal file ..."
        cp "Programs/Source/dorydb_point_roundopt_""$i""_""$3""_""$4""_$5"".mpc" "Programs/Source/dorydb_point_roundopt_mal_""$i""_""$3""_""$4""_$5"".mpc"
        ./compile.py -Z 3 -R 72 "dorydb_point_roundopt_mal_""$i""_""$3""_""$4""_$5"".mpc"
    fi

done

# using 72 bits for malicious because 128 - 40 = 88 requires recompilation of the whole VM
