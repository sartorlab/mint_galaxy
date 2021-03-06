#!/bin/bash
set -e
set -u
set -o pipefail

peprChip1=$1
peprChip2=$2
peprCombinedBB=$3
chip1Name=$4
chip2Name=$5




PePrCombinedAnnt=$6
cat <(awk -v OFS="\t" -v CHIP1=${chip1Name} '{print $1, $2, $3, CHIP1, $7, "*", $8}'  ${peprChip1}  ) <(awk -v OFS="\t" -v CHIP2=${chip2Name} '{print $1, $2, $3, CHIP2, $7, "*", $8}'  ${peprChip2} ) > ${PePrCombinedAnnt}


dir=`mktemp -d` 
echo ${dir}



disChip1=${dir}/PePr_chip1_peaks_disjoint_chip1.bed
disChip2=${dir}/PePr_chip1_peaks_disjoint_chip2.bed

bedops --difference ${peprChip1} ${peprChip2} | sort -T . -k1,1 -k2,2n > $disChip1


bedops --difference ${peprChip2} ${peprChip1} | sort -T . -k1,1 -k2,2n > $disChip2

cat <(awk -v OFS="\t" -v CHIP1=${chip1Name} '{ print $1, $2, $3, CHIP1, "1000", ".", $2, $3, "0,0,255" }' ${disChip1}) <(awk -v OFS="\t" -v CHIP2=${chip2Name} '{ print $1, $2, $3, CHIP2, "1000", ".", $2, $3, "102,102,255" }' ${disChip2}) | sort -T . -k1,1 -k2,2n > ${peprCombinedBB}
