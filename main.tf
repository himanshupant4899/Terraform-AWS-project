
# Provider is used to interact with the API of the platform you are working with.
provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "myapp-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.avail_zone]
  public_subnets  = [var.subnet_cidr_block]
  public_subnet_tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}


module "webserver" {
  source = "./modules/webserver"
  avail_zone = var.avail_zone
  my_ip = var.my_ip
  vpc_id = module.vpc.vpc_id
  env_prefix = var.env_prefix
  instance_type = var.instance_type
  public_key_location = var.public_key_location
  my_app_subnet_id = module.vpc.public_subnets[0]
  image_name = var.image_name
}

