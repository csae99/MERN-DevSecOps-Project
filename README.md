I'll recreate a comprehensive README that guides users through the complete end-to-end deployment. Based on the project structure, this is a Three-Tier MERN application with full DevSecOps pipeline.

````markdown path=README.md mode=EDIT
# Three-Tier Web Application Deployment on AWS EKS using DevSecOps Pipeline

Welcome to the comprehensive Three-Tier Web Application Deployment project! 🚀

This repository demonstrates a complete DevSecOps pipeline for deploying a MERN stack application (MongoDB, Express.js, React, Node.js) on AWS EKS with automated CI/CD, monitoring, and GitOps practices.

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │    Backend      │    │    Database     │
│   (React)       │◄──►│   (Node.js)     │◄──►│   (MongoDB)     │
│   Port: 3000    │    │   Port: 3500    │    │   Port: 27017   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Infrastructure Components
- **AWS EKS**: Kubernetes cluster for container orchestration
- **Jenkins**: CI/CD pipeline with master-slave architecture
- **ArgoCD**: GitOps-based continuous deployment
- **Prometheus & Grafana**: Monitoring and observability
- **SonarQube**: Code quality analysis
- **Trivy**: Container vulnerability scanning
- **AWS ECR**: Private container registry

## 📋 Prerequisites

Before starting, ensure you have:

- AWS account with appropriate IAM permissions
- Domain name (for Load Balancer configuration)
- Local development environment with:
  - AWS CLI v2+
  - Terraform v1.4+
  - kubectl
  - Docker
  - Git

## 🚀 Quick Start Guide

### Phase 1: Infrastructure Setup

#### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd End-to-End-Kubernetes-Three-Tier-DevSecOps-Project
```

#### 2. Configure AWS CLI
```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, Region, and Output format
```

#### 3. Deploy Infrastructure with Terraform
```bash
cd Terraform
terraform init
terraform validate
terraform plan -var 'key_name=your-keypair-name'
terraform apply -var 'key_name=your-keypair-name'
```

This creates:
- VPC with public subnet
- Jenkins Master EC2 instance (t3a.medium)
- Agent Node EC2 instance (t3a.large)
- Security Groups
- IAM roles and policies

#### 4. Access Jenkins
After Terraform deployment:
1. Get Jenkins Master public IP from Terraform output
2. Access Jenkins at `http://<jenkins-master-ip>:8080`
3. Retrieve initial admin password:
```bash
ssh -i your-keypair.pem ubuntu@<jenkins-master-ip>
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Phase 2: Jenkins Configuration

#### 1. Install Required Plugins
- Docker Pipeline
- Kubernetes
- AWS Steps
- SonarQube Scanner
- GitHub Integration

#### 2. Configure Jenkins Credentials
Add the following credentials in Jenkins:
- `github`: GitHub Personal Access Token
- `docker-cred`: Docker Hub credentials
- `jenkins-token`: Jenkins API token
- `sonar-token`: SonarQube token

#### 3. Configure Jenkins Agents
Connect the Agent Node to Jenkins Master for distributed builds.

### Phase 3: Application Deployment

#### 1. Create EKS Cluster
```bash
# On Agent Node
eksctl create cluster --name three-tier-cluster --region us-west-2 --node-type t3.medium --nodes-min 2 --nodes-max 4
```

#### 2. Configure kubectl
```bash
aws eks update-kubeconfig --region us-west-2 --name three-tier-cluster
```

#### 3. Create Kubernetes Namespace
```bash
kubectl create namespace three-tier
```

#### 4. Deploy MongoDB
```bash
cd Kubernetes-Manifests-file/Database
kubectl apply -f .
```

#### 5. Create ECR Repositories
```bash
# Frontend repository
aws ecr create-repository --repository-name frontend --region us-west-2

# Backend repository
aws ecr create-repository --repository-name backend --region us-west-2
```

#### 6. Run Jenkins Pipelines
1. Create Jenkins pipeline for Backend:
   - Use `Jenkins-Pipeline-Code/Jenkinsfile-Backend`
   - Configure ECR repository name
   - Run the pipeline

2. Create Jenkins pipeline for Frontend:
   - Use `Jenkins-Pipeline-Code/Jenkinsfile-Frontend`
   - Configure ECR repository name
   - Run the pipeline

### Phase 4: GitOps with ArgoCD

#### 1. Install ArgoCD
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

#### 2. Access ArgoCD UI
```bash
# Get ArgoCD admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port forward to access UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

#### 3. Configure ArgoCD Application
Create ArgoCD application pointing to your Kubernetes manifests repository.

### Phase 5: Monitoring Setup

#### 1. Install Prometheus and Grafana using Helm
```bash
# Add Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

# Install Grafana
helm install grafana grafana/grafana -n monitoring
```

#### 2. Access Monitoring Dashboards
```bash
# Get Grafana admin password
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode

# Port forward to access Grafana
kubectl port-forward --namespace monitoring svc/grafana 3000:80
```

### Phase 6: Load Balancer Configuration

#### 1. Install AWS Load Balancer Controller
```bash
# Create IAM OIDC provider
eksctl utils associate-iam-oidc-provider --region=us-west-2 --cluster=three-tier-cluster --approve

# Create IAM policy and service account
curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/install/iam_policy.json
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json

# Install AWS Load Balancer Controller
helm repo add eks https://aws.github.io/eks-charts
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=three-tier-cluster
```

#### 2. Configure Ingress
```bash
cd Kubernetes-Manifests-file
kubectl apply -f ingress.yaml
```

## 📁 Project Structure

```
├── Application-Code/
│   ├── frontend/          # React.js application
│   └── backend/           # Node.js/Express API
├── Jenkins-Pipeline-Code/
│   ├── Jenkinsfile-Frontend
│   └── Jenkinsfile-Backend
├── Jenkins-Server-TF/     # Terraform for Jenkins infrastructure
├── Kubernetes-Manifests-file/
│   ├── Frontend/          # Frontend K8s manifests
│   ├── Backend/           # Backend K8s manifests
│   ├── Database/          # MongoDB K8s manifests
│   └── ingress.yaml       # Ingress configuration
└── Terraform/             # Main infrastructure Terraform
```

## 🔧 Configuration Details

### Environment Variables

#### Frontend (`REACT_APP_BACKEND_URL`)
```yaml
env:
  - name: REACT_APP_BACKEND_URL
    value: "http://your-domain.com/api/tasks"
```

#### Backend Database Connection
```yaml
env:
  - name: MONGO_CONN_STR
    value: mongodb://mongodb-svc:27017/todo?directConnection=true
  - name: MONGO_USERNAME
    valueFrom:
      secretKeyRef:
        name: mongo-sec
        key: username
  - name: MONGO_PASSWORD
    valueFrom:
      secretKeyRef:
        name: mongo-sec
        key: password
```

### Jenkins Pipeline Features

- **Code Quality**: SonarQube analysis
- **Security Scanning**: Trivy vulnerability scanning
- **Container Registry**: AWS ECR integration
- **Automated Deployment**: GitOps with ArgoCD
- **Notifications**: Build status notifications

## 🔍 Monitoring and Observability

### Prometheus Metrics
- Kubernetes cluster metrics
- Application performance metrics
- Resource utilization

### Grafana Dashboards
- Kubernetes cluster overview
- Application performance
- Infrastructure monitoring

## 🛡️ Security Features

- **Container Scanning**: Trivy for vulnerability assessment
- **Code Quality**: SonarQube for code analysis
- **Secret Management**: Kubernetes secrets
- **Network Policies**: Kubernetes network segmentation
- **RBAC**: Role-based access control

## 🚨 Troubleshooting

### Common Issues

1. **Jenkins Pipeline Failures**
   - Check AWS credentials configuration
   - Verify ECR repository permissions
   - Ensure Docker daemon is running

2. **EKS Cluster Issues**
   - Verify IAM permissions
   - Check VPC and subnet configuration
   - Ensure kubectl is properly configured

3. **Application Connectivity**
   - Check service endpoints
   - Verify ingress configuration
   - Test database connectivity

### Useful Commands

```bash
# Check pod status
kubectl get pods -n three-tier

# View pod logs
kubectl logs <pod-name> -n three-tier

# Describe service
kubectl describe svc <service-name> -n three-tier

# Check ingress
kubectl get ingress -n three-tier
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📚 Additional Resources

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Next Steps

After successful deployment:
1. Configure custom domain with SSL/TLS
2. Implement backup strategies
3. Set up log aggregation
4. Configure alerting rules
5. Implement disaster recovery

---

**Happy DevOps! 🚀**

For detailed step-by-step guidance, refer to our [comprehensive guide](https://amanpathakdevops.medium.com/advanced-end-to-end-devsecops-kubernetes-three-tier-project-using-aws-eks-argocd-prometheus-fbbfdb956d1a).
````
