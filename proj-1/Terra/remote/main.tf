terraform {
	required_version = ">= 1.10.3"
}
       provider "aws" {}

	resource "aws_s3_bucket" "terra_state" {
		bucket = "state.of.terra.3232"
	     versioning {
		   enabled = true
		}
	     server_side_encryption_configuration {
		rule {
		  apply_server_side_encryption_by_default {
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
