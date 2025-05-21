#!/bin/bash
set -e

cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
rm ~/.ssh/id_ed25519.pub

sudo dnf update -y
sudo dnf upgrade -y
sudo dnf install -y dnf-plugins-core

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

sudo dnf install -y unzip
sudo dnf install -y java-21-openjdk-devel
 
wget https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip
unzip sqlcl-latest.zip
rm -f sqlcl-latest.zip
sudo mv sqlcl /opt/sqlcl
sudo ln -s /opt/sqlcl/bin/sql /usr/local/bin/sql

echo "Usuário adicionado ao grupo docker. Por favor, reconecte-se para que as permissões tenham efeito."
exit