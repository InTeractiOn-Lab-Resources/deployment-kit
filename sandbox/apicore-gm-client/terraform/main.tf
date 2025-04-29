provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "default" {
  key_name = "caro-key-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  public_key = var.inline_public_key
}

resource "aws_instance" "sandbox" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.sandbox_sg.id]

  tags = {
    Name = "sandbox-instance"
  }
}

resource "aws_security_group" "sandbox_sg" {
  name        = "sandbox-security-group"
  description = "Allow SSH and HTTP access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sandbox-sg"
  }
}
