#!/bin/bash


 ## Important system variables

   
    # System image
    # Amazon Linux version from 2018
    # with pre installed Docker
    AMI_IMAGE="ami-0d4c310a3ab39a06b"
    
    # Memory optimised instance
    # CPU 4
    # ECU 19
    # RAM 32Gb
    # SSD 150Gb
    # PRICE 0.288
    #INSTANCE_TYPE="r5d.xlarge"
    #THREADS=4
    
    # Memory optimised instance
    # CPU 2
    # ECU 10
    # RAM 16Gb
    # SSD 75Gb
    # PRICE 0.144
    #INSTANCE_TYPE="r5d.large"
    #THREADS=2

    # Compute optimised instance
    # CPU 4
    # ECU 17
    # RAM 8Gb
    # SSD 100Gb
    # PRICE 0.192
    #INSTANCE_TYPE="c5d.xlarge"
    #THREADS=4

    # Compute optimised instance
    # CPU 2
    # ECU 9
    # RAM 4Gb
    # SSD 50Gb
    # PRICE 0.096
    INSTANCE_TYPE="c5d.large"
    THREADS=2

### Sequence files path to S3 storage

   #PROJECT_DIR="s3://penota/Pn_DAOMC_185683/"
   #PROJECT_DIR="s3://penota/Pv_DAOMC_242724/"
   #PROJECT_DIR="s3://penota/Pth_DAOMC_180753/"
   #PROJECT_DIR="s3://penota/Pv_DAOMC_211566/"
   #PROJECT_DIR="s3://penota/Pv_DAOMC_213195/"
   #PROJECT_DIR="s3://penota/Pv_DAOMC_214801/"
   #PROJECT_DIR="s3://penota/Pv_DAOMC_242725/"
   #PROJECT_DIR="s3://penota/Pv_KAS_4373/"
   PROJECT_DIR="s3://penota/Pv_KAS_4382/"
   
   ASSEMBLY_DIR=$PROJECT_DIR"spades_out"
   QUAST_OUT="quast_out"

# Working Directories
    MOUNT_DIR="/mnt/workingdrive"

# Instance log file path
    LOGFILE=$MOUNT_DIR"/sample-"$QUAST_OUT"-ins-"$INSTANCE_TYPE"-cloud-init-output.log"


UDATA="$( cat <<EOF
#!/bin/bash
  
    # Download from S3
   
    
                    mkdir $MOUNT_DIR
                    sudo mkfs.ext4 /dev/nvme1n1
                    sudo mount /dev/nvme1n1 $MOUNT_DIR
                    sudo chmod a+w $MOUNT_DIR
                    cd $MOUNT_DIR
                    
                    
                    # Sync raw data and indexes
                    
                    aws s3 cp $ASSEMBLY_DIR $MOUNT_DIR \
                    --recursive \
                    --exclude "*" \
                    --include "scaffolds.fasta"
                    
                    
                    
                    # Pulling image
                    $(aws ecr get-login --no-include-email --region ca-central-1)
                    
                    docker pull 766815054095.dkr.ecr.ca-central-1.amazonaws.com/dnquality:latest
                    
                    # RUN docker container
                    docker run \
                    -e QUAST_OUT=$QUAST_OUT \
                    --mount type=bind,source=$MOUNT_DIR,target=/mnt/workingdirectory/workingdrive \
                    766815054095.dkr.ecr.ca-central-1.amazonaws.com/dnquality
                    
                    # Sync raw data and indexes
                    
                    echo "Synking data!";
                    
                   
                    # Saving logs
                    cp /var/log/cloud-init-output.log $LOGFILE
                    
                    aws s3 sync $MOUNT_DIR $ASSEMBLY_DIR
                    
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
    