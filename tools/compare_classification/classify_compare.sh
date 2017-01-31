#!/bin/bash
set -e
set -u
set -o pipefail

# Paths from parameters
CHROM_PATH=$1
mDMup=$2
mDMdown=$3
mNoDMSignal=$4
mNoDMNoSignal=$5
hDMup=$6
hDMdown=$7
hNoDMSignal=$8
hNoDMNoSignal=${9}
outFile=${10}


ID=`basename $outFile _compare_classification.bed`

# tmp files

dir=`mktemp -d` 
echo ${dir}
# tmp files

intTmp=${dir}/${ID}_tmpIntersect.txt
classTmp=${dir}/${ID}_tmpCompareClass.txt
joinTmp=${dir}/${ID}_tmpCompareJoin.txt

# Create tmp class and merged files
classesTmp=tmp6,tmp10,tmp1422,tmp12,tmp20,tmp2844,tmp1824,tmp3040,tmp426656,tmp88
filesTmp='eval echo ${dir}/${ID}_{$classesTmp}.txt'
mergesTmp='eval echo ${dir}/${ID}_{$classesTmp}.txt.merged'
# Create empty files
for file in ${filesTmp}
do
	touch $file
done

# Initial intersection
bedtools multiinter \
	-header \
	-names mDMup mDMdown mNoDMSignal mNoDMNoSignal hDMup hDMdown hNoDMSignal hNoDMNoSignal \
	-empty \
	-i ${mDMup} ${mDMdown} ${mNoDMSignal} ${mNoDMNoSignal} ${hDMup} ${hDMdown} ${hNoDMSignal} ${hNoDMNoSignal} \
	-g ${CHROM_PATH} \
> ${intTmp}

# Encode each region with the appropriate classification
# Columns 6-12 are the binary columns that should be operated on
awk-v OFS="\t" 'NR > 1 { \
	outFile = FILENAME; \
	group1 = ($6 * 3) + ($7 * 5) + ($8 * 7) + ($9 * 11); \
	group2 = ($10 * 2) + ($11 * 4) + ($12 * 6) + ($13 * 8); \
	if (group1 * group2 == 6) { \
		sub(/tmpIntersect/, "tmp6", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 10) { \
		sub(/tmpIntersect/, "tmp10", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 14 || group1 * group2 == 22) { \
		sub(/tmpIntersect/, "tmp1422", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 12) { \
		sub(/tmpIntersect/, "tmp12", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 20) { \
		sub(/tmpIntersect/, "tmp20", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 28 || group1 * group2 == 44) { \
		sub(/tmpIntersect/, "tmp2844", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 18 || group1 * group2 == 24) { \
		sub(/tmpIntersect/, "tmp1824", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 30 || group1 * group2 == 40) { \
		sub(/tmpIntersect/, "tmp3040", outFile); \
		print $1, $2, $3, group1, group2, group1 * group2 > outFile; \
	} else if (group1 * group2 == 42 || group1 * group2 == 66 || group1 * group2 == 56) { \
		sub(/tmpIntersect/, "tmp426656", outFile); \
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
	<(sort -T . -k2,2 ../../scripts/class_table_compare.txt) \
	<(sort -T . -k6,6 ${classTmp}) \
> ${joinTmp}

# Create the bed file
awk -v OFS="\t" '{
	print $4, $5, $6, $2, "1000", ".", $5, $6, $3
}' ${joinTmp} | sort -T . -k1,1 -k2,2n > ${outFile}

# Cleanup
rm -f ${intTmp} ${classTmp} ${joinTmp} ${filesTmp} ${mergesTmp}
