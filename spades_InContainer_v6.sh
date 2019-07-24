#!/bin/bash

# Alignment
echo "SPades alignment!"



        if [[ ! -d $SPADES_OUT ]]; then 
		        mkdir -p  $SPADES_OUT;
	fi


DATE=`date '+%Y%m%d_%H%M%S'`
SPADES_OPTIONS_YAML="spades_run_"$DATE".yaml"

echo '        [' >> $SPADES_OPTIONS_YAML

# Paired R1 and R2 files 

if [ "$PAIRED_READS_EXP" ];
then
            for files in $PAIRED_READS_EXP
            do 
                    if [[ $files == *_R1_* ]]; then
                            infileR1+=($(ls $files))
            		fi
            		
                    if [[ $files == *_R2_* ]]; then
                            infileR2+=($(ls $files))
            		fi		
            done
   
   len=${#infileR1[@]};
         
        # Adding to YAML file
cat <<EOF >> $SPADES_OPTIONS_YAML
        {
        orientation: "fr",
        type: "paired-end",
        right reads: [
 `for ((i=0;i<$len;i++)); do echo "\"/mnt/workingdirectory/workingdrive/"${infileR2[$i]}\"; done`
        ],
        left reads: [
 `for ((i=0;i<$len;i++)); do echo "\"/mnt/workingdirectory/workingdrive/"${infileR1[$i]}\"; done`
        ]
        },
EOF

fi

# Matepair R1 and R2 files 

if [ "$MATE_READS_EXP" ]; 
then

            for files in $MATE_READS_EXP
            do 
                    if [[ $files == *_R1_* ]]; then
                            infileMR1+=($(ls $files))
            		fi
            		
                    if [[ $files == *_R2_* ]]; then
                            infileMR2+=($(ls $files))
            		fi		
            done
            
    lenMP=${#infileMR1[@]};
            
         # Adding to YAML file
cat <<EOF >> $SPADES_OPTIONS_YAML
      {
        orientation: "rf",
        type: "mate-pairs",
        right reads: [
 `for ((i=0;i<$lenMP;i++)); do echo "\"/mnt/workingdirectory/workingdrive/"${infileMR1[$i]}\"; done`
        ],
        left reads: [
 `for ((i=0;i<$lenMP;i++)); do echo "\"/mnt/workingdirectory/workingdrive/"${infileMR2[$i]}\"; done`
        ]
      },
EOF

fi


# Single files

if [ "$SINGLE_READS_EXP" ];
then

                for files in $SINGLE_READS_EXP
                do 
                                infileSN+=($(ls $files))
                done

    lenSN=${#infileSN[@]};

cat <<EOF >> $SPADES_OPTIONS_YAML
      {
        type: "single",
        single reads: [
`for ((i=0;i<$lenSN;i++)); do echo "\"/mnt/workingdirectory/workingdrive/"${infileSN[$i]}\"; done`
        ]
      },
EOF

fi
# PacBio files
if [ "$PACBIO_READS_EXP" ];
then

                for files in $PACBIO_READS_EXP
                do 
                                infilePB+=($(ls $files))
                done

  lenPB=${#infilePB[@]};
                
cat <<EOF >> $SPADES_OPTIONS_YAML
      {
        type: "pacbio",
        single reads: [
`for ((i=0;i<$lenPB;i++)); do echo "\"/mnt/workingdirectory/workingdrive/"${infilePB[$i]}\"; done`
        ]
      }
EOF


fi

echo '        ]' >> $SPADES_OPTIONS_YAML


# SPAdes run

spades.py \
-o $SPADES_OUT \
-t $THREADS \
--dataset $SPADES_OPTIONS_YAML
