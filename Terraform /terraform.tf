terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40.0"  # Use a stable 5.x release
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
