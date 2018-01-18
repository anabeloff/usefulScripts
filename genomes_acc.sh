#!/bin/bash

# How to run this script.
# 0. Install 'ncftp' package on your machine
# sudo apt-get install ncftp

# 1. If you run it without any options it will download from NCBI all bacterial genomes.

# 2. If you need certain species or genus you need specify it as a first option.
# This script uses 'ncftpls' command to browse folder. It works the same as 'ls -l' command.
# EXAMPLE:
# 'genomes_acc.sh Helicobacter'
# Script adds star '*' to all keywords so this one will work with 'ncftpls' as:
# ncftpls -R ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/Helicobacter*
# It will output all folders with genomes data of Helicobacter species in database.
# DO NOT run several runs of that script in the same folder.

MAINLINK=$1

# Outputs the contents of folder.
ncftpls -R ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/$MAINLINK* | grep -o "$MAINLINK[^|]*" | sed 's/^/ftp:\/\/ftp.ncbi.nlm.nih.gov\/genomes\/genbank\/bacteria\//' > genus.tmp


# This is the link to directory where all NCBI genomes actually stored.
lnk2=ftp://ftp.ncbi.nlm.nih.gov/genomes/all/


for o in $( cat genus.tmp ); do

	name=$( echo $o | grep -o - -e "$MAINLINK[^|]*" )
	lnk=$o/latest_assembly_versions/
	ncftpls -R $lnk | grep -o -e "/GCA[^|]*$" | sed "s|\/|$lnk2|g" | sed 's/$/\//' | cat | wget -r -i -
	mv ftp.ncbi.nlm.nih.gov/genomes/all/ $name
done

rm *.tmp
rm -r ftp.ncbi.nlm.nih.gov
