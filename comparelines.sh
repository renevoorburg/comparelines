#!/bin/bash


if [ "$#" -ne 2 ]
then
    echo "Compares to files line by line to search for unique or duplicate lines."
    echo "Please two filenames names to be compared line by line."
    exit 1
fi


A=$1
B=$2

PID=$$

echo ".. for each fule, ensuring only unique lines are used.."
# and normalize line endings
cat $A | tr -d '\r' | sort | uniq > compare_normal_a_$PID
cat $B | tr -d '\r' | sort | uniq > compare_normal_b_$PID

echo "..joining.."
cat compare_normal_a_$PID compare_normal_b_$PID | sort | uniq -c | awk '{print$1" "$2}' > compare_intermediate_$PID

echo "..comparing.."
cat compare_intermediate_$PID | egrep '^2' | awk '{print$2}' > in_both
cat compare_intermediate_$PID | egrep '^1' | awk '{print$2}' > in_one

echo "..finding single values.."
cat in_one compare_normal_a_$PID | sort | uniq -c | awk '{print$1" "$2}' | egrep '^2' | awk '{print$2}' > just_in_$A
cat in_one compare_normal_b_$PID | sort | uniq -c | awk '{print$1" "$2}' | egrep '^2' | awk '{print$2}' > just_in_$B

rm *_$PID

echo "Done."
echo "Results written to files in_both , in_one , just_in_$A , just_in_$B ." 
