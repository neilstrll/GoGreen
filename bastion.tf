provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Security group for Bastion host"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["var.public_subnet_az1_cidr"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["var.public_subnet_az2_cidr"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for Web host"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["var.public_subnet_az1_cidr"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["var.public_subnet_az2_cidr"]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "web_sg"
  description = "Security group for Web host"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["var.public_subnet_az1_cidr"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["var.public_subnet_az2_cidr"]
  }
}

resource "aws_instance" "bastion" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "c6g.2xlarge"
  subnet_id     = aws_subnet.public.id
  key_name      = "bastion-host"

  security_groups = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "BastionHost"
  }
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}