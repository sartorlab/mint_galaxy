#!/bin/bash

let i=2
let j=1
echo $#
num1=$#	
test=1
num2=$(($(($num1-$test))/2))
echo $num2



input=$2
output=$1

echo "input is" $input   
echo "output is" $output 
bowtie2 -q -x /home/snehal/Galaxy/hg19/bowtie_path/base/genome -U $input | samtools view -bS - > $output
