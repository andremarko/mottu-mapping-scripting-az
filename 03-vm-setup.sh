#!/bin/bash
set -e

sudo yum update -y
sudo yum upgrade -y

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io

sudo systemctl enable docker
sudo systemctl start docker

sudo groupadd docker || true
sudo usermod -aG docker $(whoami)

sudo yum install -y java-21-openjdk
sudo yum install -y maven
