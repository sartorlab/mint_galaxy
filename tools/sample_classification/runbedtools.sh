


macNarrowPeak=$2
pullAli=$4
peak=$6
signal=$8
nopeak=${10}
nosignal=${12}
nopeaksignal=${14}
nopeaknosignal=${16}


awk -v OFS="\t" '{print $$1, $$2, $$3}' $macNarrowPeak| sort -T . -k1,1 -k2,2n  > $peak

cp $pullAli $signal

bedtools complement -g <(sort -T . -k1,1 /home/snehal/DataFiles/MethylSigPulldownSample/chromInfo_hg19.txt) -i $peak | sort -T . -k1,1 -k2,2n > $nopeak

bedtools complement -g <(sort -T . -k1,1 /home/snehal/DataFiles/MethylSigPulldownSample/chromInfo_hg19.txt) -i $signal | sort -T . -k1,1 -k2,2n > $nosignal

bedtools intersect -a $nopeak -b $signal | sort -T . -k1,1 -k2,2n > $nopeaksignal

bedtools intersect -a $nopeak -b $nosignal | sort -T . -k1,1 -k2,2n > $nopeaknosignal







