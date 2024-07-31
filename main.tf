terraform {
  backend "s3" {
    bucket = "shailandco"
    key    = "backend/terraform.tfstate"
    region = "ap-south-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my_server" {
  instance_type        = "t2.micro"
  ami                  = "ami-02a2af70a66af6dfb"
  key_name             = "newone"
  availability_zone    = "ap-south-1b"
  hibernation          = true

  root_block_device {
    encrypted   = true
    volume_size = 10
  }

  tags = {
    Name = "neekendukuuuu"
  }

  ebs_block_device {
    device_name             = "/dev/sdb"
    volume_size             = 8
    encrypted               = true
    delete_on_termination   = true
  }

  provisioner "local-exec" {
    command = "sleep 120 ; ansible-playbook -i ${self.public_ip}, playbook.yml --private-key /path/to/your/private-key.pem"
  }
}

output "aws_attributes" {
  value = aws_instance.my_server
}
