#!/bin/bash


# Run this script with multiple files.
# Example:
# for i in {18..34..2}; do ~/bean/mass_aodp.sh -t \*.nwk -f \*.fasta -s $i -o ../test; done


#Set options
OPTION=`getopt -o t:f:s:o: -- "$@"`
eval set -- "$OPTION";


#Default values

# OPTIONS parsing
# Concidering 2 options in this script it creates 4 numbered variables.
# shift 2 in the script allows case to move along those variables.
while true ; do
    case "$1" in
		-t ) TRE=($2); shift 2;;
		-f ) FASTA=($2); shift 2;;
		-s ) OLSIZE=$2; shift 2;;
		-o ) OUTPUT=$2; shift 2;;
		-- ) shift; break ;;
		* ) break ;;
	esac
done

# Creation arrays for multiple files
len=${#TRE[@]}
#len=0

for ((i=0;i<=$len;i++)); do 
#	echo "${TRE[0]} and ${FASTA[0]}";


aodp --tree-file=${TRE[$i]} --tab=$OUTPUT/tab_out_"$OLSIZE"_${FASTA[$i]}.txt --newick=$OUTPUT/newick.out_"$OLSIZE"_${FASTA[$i]}.txt --oligo-size=$OLSIZE --cladogram=$OUTPUT/cladogram_"$OLSIZE"_${FASTA[$i]}.eps --reverse-complement --ambiguous-sources=no ${FASTA[$i]} 

done
