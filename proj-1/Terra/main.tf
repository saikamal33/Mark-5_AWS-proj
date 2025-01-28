terraform {
	
	backend "s3" {
	   bucket   = "state.of.terra.3232" #name of the S3 created
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
	 resource "aws_security_group" "sg" {
                name        = "my-security-group"
                description = "Allow inbound SSH traffic"

	  
# Define ingress rules allow SSH
         ingress {
                from_port   = 22
                to_port     = 22
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  		}
# Define egress rule (e.g., allow all outbound traffic)
  	egress {
    		from_port   = 0
    		to_port     = 0
    		protocol    = "-1"  # All protocols
    		cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
 	 	}
	}

#to create an EC2 instance#
	resource "aws_key_pair" "secure" {
 		 key_name   = "my-new-key"             # Name for the new key pair
  		public_key = file("~/.ssh/id_rsa.pub") # Path to the public key file on your system	
	}	

	
	resource "aws_instance" "server" {
		ami = "${var.ami_var}"
		instance_type = "t2.micro"
		key_name = aws_key_pair.secure.key_name
	        security_groups = [aws_security_group.sg.name]
	
	tags = {
			name = "Terraform_EC2"

        }

}
