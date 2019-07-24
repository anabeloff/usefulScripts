#!/bin/bash

# HOW TO RUN
# Example
#	~/batch_ren.sh -f "*.gz" -p "_" -n "_R"

# IMPORTANT
# ALL options must be in quotes.


#Set options
OPTION=`getopt -o p:f:n: -- "$@"`
eval set -- "$OPTION";

# OPTIONS parsing

while true ; do
    case "$1" in
		-p ) pattern=$2; shift 2;;
		-f ) FILES=("$2"); shift 2;;
		-n ) replace=$2; shift 2;;
		-- ) shift; break ;;
		* ) break ;;
	esac
done


for i in ${FILES[@]} ; do 
#BASEPATH="s3://aafcdata/no3_Pathotype_6vs8/"
oldName=$i
newName=${i/$pattern/$replace}

#	mv "$i" "${i/$pattern/$replace}";
#	aws s3 mv "$oldName" "$newName";
	echo "$newName";
	
done 

# Examples
# ~/batch_ren.sh -p "_S[0-9]*_L" -n "_S_L" -f "Sam*"