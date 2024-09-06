# Declaring Terraform Version Required
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }

  required_version = ">= 0.14.9"
}

# Delcaring Provider
provider "aws" {
  region = var.region
}

# Creating VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  name = "${var.project_name}-vpc"
  cidr = "192.168.0.0/24"

  azs             = var.availability_zones
  public_subnets  = [var.pub_ip]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

