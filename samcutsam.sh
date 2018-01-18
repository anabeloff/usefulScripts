#!/bin/bash

# How many timess individual oligos aligned to each genome (chromosome or other sequence) in your set?

# $1 - <path> to .sam file from Bowtie2 
# $2 - number of times primer aligned to each individual genome/chromosome
# $3 - on how many genomes this primer present. Or simply total number of genomes.

## EXAMPLE ##
# If you want your primers to be present on each genome once and you have 5 genomes, you put:
# ./samcutsam.sh bowtie2.sam 1 5


cut -f1,3 $1 | sort | uniq -c | grep "^      ['$2'] " | sed 's/      ['$2'] //g' | cut -f1 | uniq -c | grep "^      ['$3'] " |  sed 's/      ['$3'] //g' | grep -f - $1
