resource "aws_default_security_group" "default-sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = [var.my_ip]
  }

    ingress {
    from_port = 8080
    protocol  = "tcp"
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    tags = {
    Name = "${var.env_prefix}-sg"
  }
}

data "aws_ami" "latest-amz-linux-image" {
  most_recent = true
  owners = ["137112412989"]
  filter {
    name   = "name"
    values = [var.image_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-instance" {
  ami = data.aws_ami.latest-amz-linux-image.id
  instance_type = var.instance_type
  subnet_id = var.my_app_subnet_id
  security_groups = [aws_default_security_group.default-sg.id]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name
  user_data = file("./modules/webserver/entry-script.sh")
  tags = {
    Name = "${var.env_prefix}-server"
  }
}