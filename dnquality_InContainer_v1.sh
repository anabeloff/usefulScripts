#!/bin/bash

echo "Quast quality check!"


# Identify R1 and R2 files 
for files in *.fasta
do 
                infile+=($(ls $files))

done

len=${#infile[@]};
        
for ((i=0;i<$len;i++));
do              
DATE=`date '+%Y%m%d_%H%M%S'`
OUTD=$QUAST_OUT"_"${infile[$i]}"_"$DATE

quast.py \
-o $OUTD \
--min-contig 50000 \
${infile[$i]}

done
