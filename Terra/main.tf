terraform {
	required_provider {
	   aws = {
      	     source = "hashicorp/aws"
	     version = "~> 5.0"
     	     }
	}
	required_version = ">= 1.10.3"


	Provider "aws" {
   	   region = "us-east-1"
	}

	resource "aws_instance" "server" {
		ami = "${var.ami_var}"
		instance_type = "t2.micro"
	
	        tags = {
			name = "Terraform_EC2"
	}
	

}
