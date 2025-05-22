#!/bin/bash
set -e

sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io

sudo systemctl enable docker
sudo systemctl start docker
sudo groupadd docker || true
sudo usermod -aG docker $(whoami)

sudo dnf install -y git
git config --global user.name "andremarko"
git config --global user.email "andre.marcolongo@gmail.com"
ssh -o StrictHostKeyChecking=no -T git@github.com 

