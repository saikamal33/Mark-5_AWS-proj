#!/bin/bash

#to update the ec2 instance
sudo apt update
sudo apt install python3-six
sudo pip3 install six
sudo apt install nginx git

#start and enable nginx

sudo systemctl start nginx
sudo systemctl enable nginx

##print success message

echo "EC2 is configured"
