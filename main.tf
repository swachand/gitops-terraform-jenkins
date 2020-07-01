# Terraform state will be stored in S3
terraform {
  backend "s3" {
    bucket = "terraform-bucket-swach"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

# Use AWS Terraform provider
provider "aws" {
  region = "ap-south-1"
}

# Create EC2 instance
resource "aws_instance" "default" {
  ami                    = var.ami
  count                  = var.instance_count
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.default.id]
  source_dest_check      = false
  instance_type          = var.instance_type

  tags = {
    Name = "terraform-default"
  }
}

# Create Security Group for EC2
resource "aws_security_group" "default" {
  name = "terraform-default-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
}
