# Terraform AWS DevSecOps Setup

# DevSecOps Demo Project — MERN Stack CI/CD on AWS with Terraform

## Overview

This project demonstrates a secure DevSecOps pipeline using a MERN stack application deployed via Jenkins (master-slave architecture) on AWS EC2 instances. The infrastructure is provisioned using Terraform with modular design.

---

## Architecture

- **Terraform**: Infrastructure as Code (IaC) for AWS provisioning
- **AWS Resources**:
  - VPC with public subnet
  - Two EC2 instances:
    - **Jenkins Master** (`t3a.medium`): Jenkins, Docker, SonarQube, Trivy
    - **Agent Node** (`t3a.large`): Docker, Kubernetes (kind), ArgoCD, Prometheus, Grafana
  - Separate Security Groups for Jenkins and Agent nodes
- **CI/CD Tools**:
  - Jenkins Master-Slave setup with Docker agents
  - SonarQube for code quality analysis
  - Trivy for container vulnerability scanning
  - ArgoCD for GitOps-based Kubernetes deployment
  - Prometheus & Grafana for monitoring Kubernetes cluster

---

## Prerequisites

- AWS account with IAM permissions to create EC2, VPC, Security Groups, etc.
- Terraform v1.4+ installed locally
- AWS CLI configured (`aws configure`)
- SSH key pair for EC2 access
- Your public IP address (to restrict SSH in security groups, optional)

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/devsecops-terraform-demo.git
cd devsecops-terraform-demo


## Usage

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply -var 'key_name=your-keypair'

