#!/bin/bash

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


#	mv "$i" "${i/$pattern/$replace}";
	echo "${i/$pattern/$replace}";
	
done 
