terraform {
  backend "s3" {
    bucket = "mybucketviv"
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
  ami                  = "ami-068e0f1a600cd311c"
  key_name             = "mum"
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
    command = "sleep 120 ; sudo ansible-playbook -i ${self.public_ip}, playbook.yaml --private-key /tmp/keys/mum.pem ANSIBLE_HOST_KEY_CHECKING=FALSE"
  }
}

output "aws_attributes" {
  value = aws_instance.my_server
}
