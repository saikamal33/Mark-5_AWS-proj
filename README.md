# Mark-5
# AWS Concepts

## Permissions Policy 

They define what action a user, group, are role can perform and on which resources. they are of two types

1) **Managed Policies** --> They can be attached to multiple identities. And they can be reused across other roles/users.

      - AWS Managed Policy :--> provided by AWS
      - Customer managed Policy:--> Created and managed by us
        
2) **inline Policies** -->Attached directly to a single identity (e.g., one IAM role), they are tightly coupled to that identity if the identity is deleted, the policy is deleted too.
Not reusable or shareable across other roles/users

**NOTE** : we can attach inline policies directlry inside of managed policies

## Difference between Client & Resource in boto3:

### Boto3.Client:
- It is a low-level service client that maps directly to AWS service APIs. It is when we want fine-grained control (or) access to all API features. it gives us access to all AWS service operations.

- The Resource API for s3 exists but is limited compared to client API.

### Boto3.Resource:
- It is a high level, object oriented API that abstracts many details more python oriented & Easier to use for common tasks. It is used when we want to work with objects directly(tables items) in a more intuitive way.

- Resources like dynamoDBs resource API is rich and let us work directly with table objects, items, etc. it simplifies CRUD operations & Provide high level abstractions & Makes code cleaner.



## Project-1
This project will automate the process of launching an EC2 instance on AWS, configure it using a shell script, and set up the environment using Ansible. You'll use Git for version control and store the code on GitHub.

## Project-2
### Scenario
we have a team of developers who need access to Amazon S3 for storing and retrieving objects, but they shouldn't be able to delete any objects or modify bucket permissions. Additionally, they should only be able to access one specific S3 bucket (let’s call it dev-bucket), not any other buckets in your AWS account.

### Objective
#### Create a custom IAM policy that grants the following permissions:

Full access to read, write, and list objects within the dev-bucket.

No permissions to delete objects in the dev-bucket.

No permissions to modify the S3 bucket itself, like changing bucket policies or configurations.

The task is to create an IAM policy with the required permissions that can be assigned to the developer group.

## Aws CLI command

To view the aws ec2 instances in table format.

      aws ec2 describe-instances \
    --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`]|[0].Value, InstanceId, PublicIpAddress, State.Name]' \
    --output table \
    --region eu-north-1 
