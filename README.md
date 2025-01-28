# Mark-5

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
