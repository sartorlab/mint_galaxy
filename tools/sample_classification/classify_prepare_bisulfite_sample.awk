#!/usr/bin/awk -f
BEGIN {OFS="\t"}
{
	outFile = FILENAME

	if ( ($4 + $5 >= MIN_COV) && ($4 / ($4 + $5) >= 0.5) ) {print $1, $2 - 1, $2 > himeth} 
	else if ( ($4 + $5 >= MIN_COV) && ($4 / ($4 + $5) > 0.05) && ($4 / ($4 + $5) < 0.5) ) {	print $1, $2 - 1, $2 > lowmeth} 
        else if ( ($4 + $5 >= MIN_COV) && ($4 / ($4 + $5) <= 0.05) ) {print $1, $2 - 1, $2 > nomethsignal} 
        else {print $1, $2 - 1, $2 > nomethnosignal}
}

