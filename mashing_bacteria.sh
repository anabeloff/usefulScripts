#!/bin/bash


# INSTALL MASH
# Link for sourse code to install MASH
# https://github.com/marbl/Mash


# HOW TO RUN SCRIPT?
# To run script supply it genome files in command line, one after another. 
# There could be as many genomes as you like.
# Example1:
#	./mashing_genomes.sh genome1 genome2 genome3 genome4 genome4 ...
# Example2:
#	./mashing_genomes.sh genomes_dir/*.fasta

########################################## SCRIPT #######################################################
# Create an empty file
	> mashed.tab

for i in $@; do

	mash dist $i $@ >> mashed.tab

done
