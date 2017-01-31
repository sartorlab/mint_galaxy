


input=$2
dmup=$4
dmdown=$6
nodmsig=$8
nodmnosig=${10}
fdr=${12}
diff=${14}
chrom_path=${16}


awk -v OFS="\t" -v FDR=$fdr -v DIFF=$diff 'NR > 1 && $6 < FDR && $7 > DIFF { print $1, $2 - 1, $3 }' $input | sort -T . -k1,1 -k2,2n > $dmup

awk -v OFS="\t" -v FDR=$fdr -v DIFF=$diff 'NR > 1 && $6 < FDR && $7 < DIFF*(-1) { print $1, $2 - 1, $3 }' $input | sort -T $(DIR_TMP) -k1,1 -k2,2n > $dmdown

awk -v OFS="\t" -v FDR=$fdr 'NR > 1 && $6 > FDR { print $1, $2 - 1, $3 }' $input | sort -T . -k1,1 -k2,2n > $nodmsig

bedtools complement -i < awk -v OFS="\t" 'NR > 1 { print $1, $2 - 1, $3 }' $input) -g <(sort -T . -k1,1 $chrom_path) | sort -T . -k1,1 -k2,2n > $nodmnosig







