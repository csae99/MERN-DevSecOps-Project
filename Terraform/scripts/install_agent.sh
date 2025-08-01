#!/bin/bash
# For Ubuntu 22.04
# Intsalling Java
sudo apt update -y
sudo apt install openjdk-21-jdk-headless -y
java --version

#!/bin/bash
set -e

# Update and install base tools
sudo apt-get update -y
sudo apt-get install -y docker.io curl wget apt-transport-https gnupg2 software-properties-common

# Enable Docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER && newgrp docker

# Install kind (Kubernetes in Docker)
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x kind
sudo mv kind /usr/local/bin/

# Install kubectl
curl -LO "https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Create Kubernetes cluster with kind
curl -LO "https://github.com/csae99/MERN-DevSecOps-Project/blob/master/Terraform/scripts/kind-config.yaml"
kind create cluster --name devsecops-cluster --config kind-config.yaml

# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Install Prometheus & Grafana using Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring
helm install prometheus prometheus-community/prometheus --namespace monitoring

helm install grafana prometheus-community/grafana --namespace monitoring --set adminPassword='admin' --set service.type=NodePort --set service.nodePort=30000

echo "Agent setup with kind, ArgoCD, Prometheus, and Grafana completed."
