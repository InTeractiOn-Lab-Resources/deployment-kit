provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "default" {
  key_name   = "caro-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "sandbox" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.default.key_name

  tags = {
    Name = "sandbox-instance"
  }
}

