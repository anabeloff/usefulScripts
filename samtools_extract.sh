#!/bin/bash


MOUNT_DIR="/mnt/workingdrive"

if [[ ! -d extracted_bam ]]; then 
        mkdir -p  extracted_bam;
fi



cat <<EOF >> $MOUNT_DIR/script.sh
#!/bin/bash

for bamfile in *.bam;
do
seqnames=( `samtools idxstats $bamfile | cut -f1 | grep "$spnames*"` );
                
samtools view -bh $bamfile "${seqnames[@]}" > "extracted_bam/"$spnames"_"${bamfile%%.sam*}".bam"
done

samtools merge "extracted_bam/"$spnames"_merged.bam" "extracted_bam/"$spnames*".bam"

rm extracted_bam/_*

EOF

pennames=("Pn_DAOMC_185683" "Pv_DAOMC_242724" "Pth_DAOMC_180753" "Pv_DAOMC_211566" "Pv_DAOMC_213195" "Pv_DAOMC_214801" "Pv_DAOMC_242725" "Pv_KAS_4373" "Pv_KAS_4382")


for spnames in ${pennames[@]};
do

               docker run \
                -e spnames=$spnames \
                --mount type=bind,source=$MOUNT_DIR,target=/usr/local/src/rnaSeq/workingdrive \
                766815054095.dkr.ecr.ca-central-1.amazonaws.com/rnaseqpipe \
                /usr/local/src/rnaSeq/workingdrive/script.sh

            
            aws s3 sync . s3://penota/genomes/star_out/
            
            sudo rm extracted_bam/*
done

sudo shutdown -h now