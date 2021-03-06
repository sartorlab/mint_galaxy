#!/bin/bash
set -e
set -u
set -o pipefail

# Paths from parameters
CHROM_PATH=$1
outFile=$9
highMeth=$2
lowMeth=$3
noMethSig=$4
noMethNoSig=$5
peak=$6
noPeakSig=${7}
noPeakNoSig=${8}
ID=`basename $outFile _sample_classification.bed`
echo $ID

dir=`mktemp -d` 
echo ${dir}
# tmp files
intTmp=${dir}/${ID}_tmpIntersect.txt
classTmp=${dir}/${ID}_tmpSampleClass.txt
joinTmp=${dir}/${ID}_tmpSampleJoin.txt

# Create tmp class and merged files
classesTmp=tmp6101422,tmp12,tmp20,tmp18,tmp30,tmp284244,tmp66
filesTmp=`eval echo ${dir}/${ID}_{$classesTmp}.txt`
mergesTmp=`eval echo ${dir}/${ID}_{$classesTmp}.txt.merged`
# Create empty files
for file in ${filesTmp}
do
	> $file
done

# Initial intersection
bedtools multiinter \
	-header \
	-names highMeth lowMeth noMethSig noMethNoSig peak noPeakSig noPeakNoSig \
	-empty \
	-i ${highMeth} ${lowMeth} ${noMethSig} ${noMethNoSig} ${peak} ${noPeakSig} ${noPeakNoSig} \
	-g ${CHROM_PATH} \
> ${intTmp}

# Encode each region with the appropriate classification
# Columns 6-12 are the binary columns that should be operated on
awk -v OFS="\t" 'NR > 1 { \
	outFile = FILENAME; \
	group1 = ($6 * 3) + ($7 * 5) + ($8 * 7) + ($9 * 11); \
	group2 = ($10 * 2) + ($11 * 4) + ($12 * 6); \
	if (group1 * group2 == 6 || group1 * group2 == 10 || group1 * group2 == 14 || group1 * group2 == 22) { \
		sub(/tmpIntersect/, "tmp6101422", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 12) { \
		sub(/tmpIntersect/, "tmp12", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 20) { \
		sub(/tmpIntersect/, "tmp20", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 18) { \
		sub(/tmpIntersect/, "tmp18", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 30) { \
		sub(/tmpIntersect/, "tmp30", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 28 || group1 * group2 == 42 || group1 * group2 == 44) { \
		sub(/tmpIntersect/, "tmp284244", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 66) { \
		sub(/tmpIntersect/, "tmp66", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} \
}' ${intTmp}

# Bedtools merge each of the files
for file in ${filesTmp}
do
	# Check that the file exists and has a size greater than 0
	if [ -s ${file} ]
	then
		bedtools merge -i <(sort -T . -k1,1 -k2,2n ${file}) -c 4,5,6 -o first,first,first > ${file}.merged
	else
		> ${file}.merged
	fi
done

# Combine and sort in preparation for joining with the table
cat ${mergesTmp} | sort -T . -k1,1 -k2,2n > ${classTmp}

# Join on the classification code
# NOTE: Files must be sorted on the join field (code)
join \
	-1 2 \
	-2 6 \
	<(sort -T . -k2,2 /home/snehal/Galaxy/galaxyLatest/galaxy/tools/sample_classification/class_table_hybrid_sample.txt) \
	<(sort -T . -k6,6 ${classTmp}) \
> ${joinTmp}

# Create the bed file
awk -v OFS="\t" '{
	print $4, $5, $6, $2, "1000", ".", $5, $6, $3
}' ${joinTmp} | sort -T . -k1,1 -k2,2n > ${outFile}

# Cleanup
rm -f ${intTmp} ${classTmp} ${joinTmp} ${filesTmp} ${mergesTmp}

