terraform {
	
	backend "s3" {
	   bucket   = "state_of_terra" #name of the S3 created
	   key      = "global/terraform.tfstate" #where the state is stored in S3
	   encrypt  = true
	   region   = "us-east-1"
	   dynamodb_table = "terra-lock" #name of the dynamic table created
	}	

	required_providers {
	   aws = {
      	     source = "hashicorp/aws"
	     version = "~> 5.0"
     	     }
	}
	required_version = ">= 1.10.3"

}
	provider "aws" {
   	   region = "us-east-1"
	}
#to create an EC2 instance#

	resource "aws_instance" "server" {
		ami = "${var.ami_var}"
		instance_type = "t2.micro"
	
	        tags = {
			name = "Terraform_EC2"
	         }
	}
#to create S3 to store state files#

	resource "aws_s3_bucket" "terra_state" {
		bucket = "state_of_terra_3232"
		versioning {
		   enabled = true
		}
	server_side_encryption_configuration {
		rule {
		  apply_server_default_encription {
			sse_algorithm = "AES256"
		        }
		   }
	     }
	}

	resource "aws_dynamodb_table" "terra_lock" {
		name = "terra-lock"
		billing_mode = "PAY_PER_REQUEST"
		hash_key = "LockID"

	attribute {
	    name = "LockID"
	    type = "S"
	}
    }



