#!/bin/bash

#echo "=== Updating system ==="
sudo apt-get update -y

#echo "=== Installing Java (required for Jenkins) ==="
sudo apt-get install -y fontconfig openjdk-17-jre

#echo "=== Adding Jenkins repo and key ==="
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

#echo "=== Installing Jenkins ==="
sudo apt-get update -y
sudo apt-get install -y jenkins

#echo "=== Enabling and starting Jenkins service ==="
sudo systemctl enable jenkins
sudo systemctl start jenkins


#echo "=== Updating system ==="
sudo apt-get update -y

#echo "=== Installing prerequisites ==="
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

#echo "=== Adding Docker’s official GPG key ==="
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

#echo "=== Setting up repository ==="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#echo "=== Installing Docker Engine ==="
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Modifying the permissions
sudo usermod -aG docker jenkins
sudo systemctl restart docker
sudo systemctl restart jenkins
# Install AWS CLI (to interact with AWS Account)
sudo apt update
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
# Install KubeCTL (to interact with K8S)
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
# Install EKS CTL (used to create EKS Cluster)
ARCH=amd64
PLATFORM=Linux_amd64
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz"
tar -xzf "eksctl_Linux_amd64.tar.gz" -C /tmp
sudo install -m 0755 /tmp/eksctl /usr/local/bin/