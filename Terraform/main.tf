provider "aws" {
  region = "ap-south-1"
}

data "aws_key_pair" "my_key" {
  key_name = var.key_name
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
  key_name       = data.aws_key_pair.my_key.key_name
  instance_name  = "jenkins-master"
  security_group_ids = [aws_security_group.jenkins_sg.id]
  user_data      = file("scripts/install_jenkins.sh")
}

module "agent_node" {
  source         = "./modules/ec2-instance"
  ami            = var.ami
  instance_type  = "t3a.medium"
  subnet_id      = module.vpc.subnet_id
  vpc_id         = module.vpc.vpc_id
  key_name       = data.aws_key_pair.my_key.key_name
  instance_name  = "agent-node"
  security_group_ids = [aws_security_group.agent_sg.id]
  user_data      = file("scripts/install_agent.sh")
}


