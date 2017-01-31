


chip1=$2
chip2=$4
mersig=$6
dmup=$8
dmdown=${10}
nodmsig=${12}
nodmnosig=${14}
fdr=${16}
diff=${18}
chrom_path=${20}


dir=`mktemp -d` 
echo ${dir}
# tmp files
tmp_up=${dir}/pulldown_tmp_up.txt
tmp_down=${dir}/pulldown_tmp_down.txt
tmp_disjoint_DM=${dir}/tmp_disjoint_DM.txt
tmp_disjoint_noDM=${dir}/tmp_disjoint_noDM.txt
tmp_signal=${dir}/tmp_signal.txt
tmp_nosignal=${dir}/tmp_nosignal.txt





awk -v OFS="\t" '{print $$1, $$2, $$3}' $chip1 | sort -T . -k1,1 -k2,2n > $tmp_up

awk -v OFS="\t" '{print $$1, $$2, $$3}' $chip2| sort -T . -k1,1 -k2,2n > $tmp_down

bedops --difference $tmp_down > $dmup

bedops --difference $tmp_up > $dmdown

cat $dmdown | sort -T . -k1,1 -k2,2n > $tmp_disjoint_DM

bedtools complement -i $tmp_disjoint_DM -g <(sort -T . -k1,1 $chrom_path) |awk -v OFS="\t" '$2 != $3 {print $0}'  > $tmp_disjoint_noDM

cp $mersig $tmp_signal

bedtools complement -i $tmp_signal -g <(sort -T . -k1,1 $chrom_path) |awk -v OFS="\t" '$2 != $3 {print $0}' > $tmp_nosignal

bedtools intersect -a $(word 1, $tmp_disjoint_noDM) -b $(word 2, $tmp_signal | sort -T . -k1,1 -k2,2n > $nodmsig

bedtools intersect -a $(word 1, $tmp_disjoint_noDM) -b $(word 2, $tmp_nosignal) | sort -T . -k1,1 -k2,2n > $nodmnosig








