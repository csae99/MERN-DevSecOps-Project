#!/bin/bash

set -e

echo "Starting setup of Agent-1..."

# Update packages
sudo apt-get update -y

# Install Git and findutils (find command)
sudo apt-get install -y git findutils curl apt-transport-https ca-certificates software-properties-common

# Install Node.js (latest LTS)
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify Node.js and npm
node -v
npm -v

# Install Gitleaks
echo "Installing Gitleaks..."
GITLEAKS_VERSION="v8.18.1"
curl -sL https://github.com/zricethezav/gitleaks/releases/download/${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION#v}_linux_x64.tar.gz | tar -xz -C /tmp
sudo mv /tmp/gitleaks /usr/local/bin/gitleaks
gitleaks --version

# Install Trivy
echo "Installing Trivy..."
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin
trivy --version

# Install OpenJDK 11 (for SonarQube Scanner)
echo "Installing OpenJDK 11..."
sudo apt-get install -y openjdk-11-jdk
java -version

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
kubectl version --client

echo "All tools installed successfully on Agent-1."
