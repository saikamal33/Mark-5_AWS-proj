#!/bin/bash

###############
#Description: Create EC2 and S3 in AWS using AWS CLI
# - Create EC2 instance with tags
# - Create a public S3 bucket
# - Upload a file to the S3 bucket
# - Take command line argument like create to create resources or teardown to delete resources
# - Include error handling
# - Prerequisites:
# - Verify if user has AWS Installed, User might be using windows or linux
# - Verify if user has AWS CLI is configured
################
# variables
EC2_TAG_KEY="shell_auto_tag"
EC2_TAG_VALUE="auto_created"
S3_BUCKET_NAME="shell-auto-bucket-genai"
FILE_TO_UPLOAD="sample.txt"
REGION="us-east-1"
INSTANCE_TYPE="t2.micro"
AMI_ID="ami-0360c520857e3138f"
KEY_NAME="proxy"

# Function to check if AWS CLI is installed
check_aws_cli() {
    if ! command -v aws &> /dev/null; then          
        echo "AWS CLI is not installed. Please install it and configure your AWS credentials."
        exit 1
    fi
}   
# Function to check if AWS CLI is configured
check_aws_configured() {
    if ! aws sts get-caller-identity &> /dev/null; then
        echo "AWS CLI is not configured. Please configure it using 'aws configure'."
        exit 1
    fi
}
# Function to create EC2 instance
create_ec2_instance() {
    echo "Creating EC2 instance..."
    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id $AMI_ID \
        --count 1 \
        --instance-type $INSTANCE_TYPE \
        --key-name $KEY_NAME \
        --security-groups $SECURITY_GROUP \
        --region $REGION \
        --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyAutomationInstance}]' \
        --query 'Instances[0].InstanceId' \
        --output text)
    if [ $? -ne 0 ]; then
        echo "Failed to create EC2 instance."
        exit 1
    fi
    echo "EC2 instance created with Instance ID: $INSTANCE_ID"
}   
# Function to create S3 bucket
create_s3_bucket() {
    echo "Creating S3 bucket..."            
    aws s3api create-bucket --bucket $S3_BUCKET_NAME --region $REGION
    if [ $? -ne 0 ]; then
        echo "Failed to create S3 bucket."
        exit 1
    fi
    echo "S3 bucket created with name: $S3_BUCKET_NAME" 
}
# Function to upload file to S3 bucket
upload_file_to_s3() {
    echo "Uploading file to S3 bucket..."
    echo "This is a sample file for upload." > $FILE_TO_UPLOAD      
    aws s3 cp $FILE_TO_UPLOAD s3://$S3_BUCKET_NAME/
    if [ $? -ne 0 ]; then
        echo "Failed to upload file to S3 bucket."
        exit 1
    fi
    echo "File uploaded to S3 bucket: $S3_BUCKET_NAME/$FILE_TO_UPLOAD"
}
# Function to teardown resources
teardown_resources() {
	
    INSTANCE_ID=$(aws ec2 describe-instances \
        --filters "Name=tag:Name,Values=MyAutomationInstance" "Name=instance-state-name,Values=running,stopped" \
        --region $REGION \
        --query 'Reservations[*].Instances[*].InstanceId' \
        --output text)

    if [ -z "$INSTANCE_ID" ]; then
        echo "No EC2 instance found with tag 'MyAutomationInstance'."
        exit 0
    fi

    echo "Terminating EC2 instance: $INSTANCE_ID"
    aws ec2 terminate-instances --instance-ids $INSTANCE_ID --region $REGION
    echo "EC2 instance terminated."
    echo "Deleting S3 bucket and its contents..."
    aws s3 rb s3://$S3_BUCKET_NAME --force
    if [ $? -ne 0 ]; then
        echo "Failed to delete S3 bucket."
        exit 1
    fi
    echo "S3 bucket deleted."
}
# Main script logic
if [ "$1" == "create" ]; then
    check_aws_cli
    check_aws_configured            
    create_ec2_instance
    create_s3_bucket
    upload_file_to_s3
    echo "Resources created successfully."
elif [ "$1" == "teardown" ]; then
    check_aws_cli
    check_aws_configured
    teardown_resources
    echo "Resources torn down successfully."
else
    echo "Usage: $0 {create|teardown}"
    exit 1
fi  

# Clean up local file
rm -f $FILE_TO_UPLOAD


