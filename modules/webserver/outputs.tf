output "instance" {
  value = aws_instance.myapp-instance
}

output "ami_data" {
  value = data.aws_ami.latest-amz-linux-image.id
}