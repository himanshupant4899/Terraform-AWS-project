provider "aws" {
  region = "ap-south-1"
}

data "aws_availability_zones" "azs"{}

variable vpc_cidr_blocks {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version         = "3.16.0"
  name            = "myapp-vpc"
  cidr            = var.vpc_cidr_blocks
  azs             = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks
  enable_nat_gateway  = true
  single_nat_gateway  = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal_elb" = 1
  }
}