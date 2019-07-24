#!/bin/bash

  
    # System image
    # Amazon Linux version from 2018
    # with pre installed Docker
    AMI_IMAGE="ami-0d4c310a3ab39a06b"
   
# Compute optimised instance
    # CPU 2
    # ECU 9
    # RAM 4Gb
    # SSD 50Gb
    # PRICE 0.096
    #INSTANCE_TYPE="c5d.large"
    #THREADS=2

# Compute optimised instance
    # CPU 4
    # ECU 17
    # RAM 8Gb
    # SSD 100Gb
    # PRICE 0.192
    # INSTANCE_TYPE="c5d.xlarge"
    # THREADS=4

# Compute optimised instance
    # CPU 16
    # ECU 68
    # RAM 32Gb
    # SSD 400Gb
    # PRICE 0.768
    INSTANCE_TYPE="c5d.4xlarge"
    THREADS=16
    
###########################
### QUALIMAP conatainer ###
###########################

# Analysis types

# Qualimap 2
# on BAM files after alignment
# Requires GTF file.
#ANALYSIS="qualimap"

#   Data for No1
#   PROJECT_DIR="s3://aafcdata/no1_Susceptible_tuber_vs_no_tuber_control/star_out/"
#   Data for No2
#   PROJECT_DIR="s3://aafcdata/no2_Susceptible_tuber_vs_resistant_tuber/star_out/"
#   Data for No3    
#   PROJECT_DIR="s3://aafcdata/no3_Pathotype_6vs8/star_out/"


# Trimming of raw reads.
# Automatically run FastQC after trimming.
 ANALYSIS="trimm"
#PROJECT_DIR="s3://penota/Pn_DAOMC_185683/"
#PROJECT_DIR="s3://penota/Pth_DAOMC_180753/"
#PROJECT_DIR="s3://penota/Pv_DAOMC_211566/"
#PROJECT_DIR="s3://penota/Pv_DAOMC_213195/"
#PROJECT_DIR="s3://penota/Pv_DAOMC_214801/"
#PROJECT_DIR="s3://penota/Pv_DAOMC_242725/"
#PROJECT_DIR="s3://penota/Pv_DAOMC_214801/"

#PROJECT_DIR="s3://penota/Pv_KAS_4373/"
#PROJECT_DIR="s3://penota/Pv_KAS_4373/"

#PROJECT_DIR="s3://penota/Pv_DAOMC_242724/DNA_Illumina/"
PROJECT_DIR="s3://penota/Pv_DAOMC_242724/RNA_Illumina/"

OUT_DIR="trimmed"

# FastQC run
#ANALYSIS="fastqc"
#PROJECT_DIR="s3://aafcdata/no2_Susceptible_tuber_vs_resistant_tuber/"

# Trimmomatic options
CROP_LEN=65
MIN_LEN=40
HEADCROP=12


# CROP_LEN=200
# MIN_LEN=180
# THREADS=2
# HEADCROP=9

# Anotation
# GTF is mandatory for rnaseq.
# GFF can be used for other analyses.
    GTFFILE=/usr/local/src/rnaSeq/workingdrive/gencode.v29.annotation.gtf
# Working Directories
    MOUNT_DIR="/mnt/workingdrive"

# Instance log file path
    DATE=`date '+%Y%m%d_%H%M%S'`
    LOGFILE="sample-"$DATE"-ins-"$INSTANCE_TYPE"-cloud-init-output.log"


UDATA="$( cat <<EOF
#!/bin/bash

    
                     sudo mkdir $MOUNT_DIR
                     sudo mkfs.ext4 /dev/nvme1n1
                     sudo mount /dev/nvme1n1 $MOUNT_DIR
                     sudo chmod a+w $MOUNT_DIR
                     cd $MOUNT_DIR
                     sudo rm -r lost+found

                     # Sync S3 data
                     aws s3 cp $PROJECT_DIR $MOUNT_DIR \
                     --recursive \
                     --exclude "*" \
                     --include "*.fq.gz"
                    
                    # Pulling image
                    $(aws ecr get-login --no-include-email --region ca-central-1)
                    
                    docker pull 766815054095.dkr.ecr.ca-central-1.amazonaws.com/qualim:latest
                    
                    # RUN docker container
                    docker run \
                    -e THREADS=$THREADS \
                    -e CROP_LEN=$CROP_LEN \
                    -e MIN_LEN=$MIN_LEN \
                    -e HEADCROP=$HEADCROP \
                    -e GTFFILE=$GTFFILE \
                    -e ANALYSIS=$ANALYSIS \
                    --mount type=bind,source=$MOUNT_DIR,target=/usr/local/src/rnaSeq/workingdrive \
                    766815054095.dkr.ecr.ca-central-1.amazonaws.com/qualim 
                    
                    # Sync raw data and indexes

                    echo "Synking data!";
            if [ "$ANALYSIS" = "qualimap" ] || [ "$ANALYSIS" = "fastqc" ]
            then
                
                cp /var/log/cloud-init-output.log $MOUNT_DIR"/"$LOGFILE
                
                aws s3 sync $MOUNT_DIR $PROJECT_DIR
                
            elif [ "$ANALYSIS" = "trimm" ] 
            then
                 # Saving logs
                cp /var/log/cloud-init-output.log $MOUNT_DIR"/trimmed/"$LOGFILE
                
                aws s3 cp $MOUNT_DIR"/trimmed/" $PROJECT_DIR$OUT_DIR --recursive --exclude "*" --include "*_paired*"
            fi
   
   
   sudo shutdown -h now
                    
EOF
)"
                        
                                  
                    
                    aws ec2 run-instances \
                        --image-id $AMI_IMAGE \
                        --iam-instance-profile Name="robotrole" \
                        --security-group-ids awsEnvTest \
                        --count 1 \
                        --instance-initiated-shutdown-behavior terminate \
                        --user-data "$UDATA" \
                        --instance-type $INSTANCE_TYPE \
                        --key-name awsKey \
                        --query 'Instances[0].InstanceId'
    