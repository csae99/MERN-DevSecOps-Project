# Terraform AWS DevSecOps Setup

## Overview

This project sets up:
- Jenkins master (t3a.medium)
- Agent node with Docker, K8s, ArgoCD, Prometheus (t3a.large)
- VPC, subnet, security groups
- EC2 with EBS gp3 volumes

## Usage

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply -var 'key_name=your-keypair'

