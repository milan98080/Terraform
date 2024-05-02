resource "aws_ec2_instance" "bastion" {
  ami           = "ami-08d4ac5b5b5b5b5b5"
  instance_type = "t2.micro"
  subnet_id = var.bastion_subnet_id
  tags = {
    Name = "bastion-host"
  }
}

