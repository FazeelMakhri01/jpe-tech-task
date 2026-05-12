terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "app_sg" {
  name        = "release-dashboard-sg"
  description = "Security group for release dashboard"

  ingress 
  {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = "t3.xlarge"

  security_groups = [aws_security_group.app_sg.name]

  tags = {
    Name = "release-status-dashboard"
  }

  user_data = <<EOF
#!/bin/bash
echo "Starting Release Status Dashboard setup"
apt-get update
apt-get install -y nodejs npm
npm install -g pm2
EOF
}

resource "aws_ebs_volume" "app_data" {
  availability_zone = "eu-west-2a"
  size              = 100

  tags = {
    Name = "release-dashboard-data"
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name = "/apps/release-status-dashboard"
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "release-status-dashboard-artifacts"
}