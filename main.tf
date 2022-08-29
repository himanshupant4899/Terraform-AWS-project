
# Provider is used to interact with the API of the platform you are working with.
provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "myapp-vpc"{
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
  source = "./modules/subnet"
  vpc_id = aws_vpc.myapp-vpc.id
  env_prefix = var.env_prefix
  avail_zone = var.avail_zone
  subnet_cidr_block = var.subnet_cidr_block
}

module "webserver" {
  source = "./modules/webserver"
  avail_zone = var.avail_zone
  my_ip = var.my_ip
  vpc_id = aws_vpc.myapp-vpc.id
  env_prefix = var.env_prefix
  instance_type = var.instance_type
  public_key_location = var.public_key_location
  my_app_subnet_id = module.myapp-subnet.subnet.id
  image_name = var.image_name
}

