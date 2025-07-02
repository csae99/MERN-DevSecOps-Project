provider "aws" {
  region = "ap-south-1"
}

# Security group for Jenkins master
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH and Jenkins UI"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for agent node
resource "aws_security_group" "agent_sg" {
  name        = "agent-sg"
  description = "Allow SSH and K8s tools"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  availability_zone   = "ap-south-1a"
  name_prefix         = "devsecops"
}

module "jenkins_master" {
  source         = "./modules/ec2-instance"
  ami            = var.ami
  instance_type  = "t3a.medium"
  subnet_id      = module.vpc.subnet_id
  vpc_id         = module.vpc.vpc_id
  key_name       = var.key_name
  instance_name  = "jenkins-master"
  security_group_ids = [aws_security_group.jenkins_sg.id]
  user_data      = file("scripts/install_jenkins.sh")
}

module "agent_node" {
  source         = "./modules/ec2-instance"
  ami            = var.ami
  instance_type  = "t3a.large"
  subnet_id      = module.vpc.subnet_id
  vpc_id         = module.vpc.vpc_id
  key_name       = var.key_name
  instance_name  = "agent-node"
  security_group_ids = [aws_security_group.agent_sg.id]
  user_data      = file("scripts/install_agent.sh")
}


