#!/bin/bash

set -e

if [ $# -lt 5 ]
then
    echo "Script expects Records_Begin Records_End BucketSize Conditions Threads"
    exit
fi

echo "Records_Begin = 1 << $1"
echo "Records_End = 1 << $2"
echo "BucketSize or Comparison Bitwidth = 1 << $3"
echo "Predicate Count or Condition Count = $4"
echo "Threads = $5"

for i in $(seq $1 2 $2)
do
    echo "Working on iteration $i"
    echo "Generating Multithreaded file ..."
    python3 generate_file.py "Programs/Source/dorydb_mthread_template.mpc" "Programs/Source/dorydb_mthread_""$i""_""$3""_""$4""_$5"".mpc" "$i" "$3" "$4" "$5"
    echo "Compiling SH Multithreaded file ..."
    ./compile.py -Z 3 -R 128 "dorydb_mthread_""$i""_""$3""_""$4""_$5"".mpc"
    echo "Compiling Mal Multithreaded file ..."
    cp "Programs/Source/dorydb_mthread_""$i""_""$3""_""$4""_$5"".mpc" "Programs/Source/dorydb_mthread_mal_""$i""_""$3""_""$4""_$5"".mpc"
    ./compile.py -Z 3 -R 72 "dorydb_mthread_mal_""$i""_""$3""_""$4""_$5"".mpc"
    
    echo "Generating Round-optimal file ..."
    python3 generate_file.py "Programs/Source/dorydb_roundopt_template.mpc" "Programs/Source/dorydb_roundopt_""$i""_""$3""_""$4""_$5"".mpc" "$i" "$3" "$4" "$5"
    echo "Compiling SH Round-optimal file ..."
    ./compile.py -Z 3 -R 128 "dorydb_roundopt_""$i""_""$3""_""$4""_$5"".mpc"
    echo "Compiling Mal Round-optimal file ..."
    cp "Programs/Source/dorydb_roundopt_""$i""_""$3""_""$4""_$5"".mpc" "Programs/Source/dorydb_roundopt_mal_""$i""_""$3""_""$4""_$5"".mpc"
    ./compile.py -Z 3 -R 72 "dorydb_roundopt_mal_""$i""_""$3""_""$4""_$5"".mpc"
done

# using 72 bits for malicious because 128 - 40 = 88 requires recompilation of the whole VM
