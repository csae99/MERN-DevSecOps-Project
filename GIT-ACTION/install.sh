#!/bin/bash

set -e

echo "🚀 Starting full setup of Agent-1..."

# Update package lists
sudo apt-get update -y

# ---------------------------------
# Install Git, findutils, curl, etc.
# ---------------------------------
sudo apt-get install -y git findutils curl apt-transport-https ca-certificates gnupg lsb-release software-properties-common

# ---------------------------------
# Install Node.js (latest LTS)
# ---------------------------------
echo "📦 Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v
npm -v

# ---------------------------------
# Install Gitleaks
# ---------------------------------
echo "🔍 Installing Gitleaks..."
GITLEAKS_VERSION="v8.18.1"
curl -sL https://github.com/zricethezav/gitleaks/releases/download/${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION#v}_linux_x64.tar.gz | tar -xz -C /tmp
sudo mv /tmp/gitleaks /usr/local/bin/gitleaks
gitleaks --version

# ---------------------------------
# Install Trivy
# ---------------------------------
echo "🛡 Installing Trivy..."
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin
trivy --version

# ---------------------------------
# Install OpenJDK 21 (headless)
# ---------------------------------
echo "☕ Installing OpenJDK 21 (headless)..."
sudo apt-get install -y openjdk-21-jdk-headless
java -version

# ---------------------------------
# Install kubectl
# ---------------------------------
echo "🧰 Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
kubectl version --client

# ---------------------------------
# Install Docker
# ---------------------------------
echo "🐳 Installing Docker..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg

# Add Docker’s official GPG key and repo
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
sudo usermod -aG docker $USER

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# ---------------------------------
# Install Minikube
# ---------------------------------
echo "📦 Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Start Minikube with Docker as the driver
echo "🚀 Starting Minikube using Docker..."
minikube start --driver=docker

# Verify Minikube is working
minikube status

echo "✅ All tools installed and Minikube started successfully on Agent-1."

echo "🔄 NOTE: You may need to log out and log back in for Docker group changes to apply."
