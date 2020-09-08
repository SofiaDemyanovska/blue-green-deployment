#!/bin/sh
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start

# Pull image from DockerHub
sudo docker pull sofdem/back

# Run docker container
sudo docker run --name backend -p 5000:80 sofdem/back
