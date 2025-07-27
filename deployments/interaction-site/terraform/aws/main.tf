# ========================================================
# TEMPLATE DE TERRAFORM PARA AWS
# Descripción: Crea una instancia EC2 con grupo de seguridad configurado
# ========================================================

# Configuración del proveedor AWS - Define la región donde se crearán los recursos
provider "aws" {
  region = var.aws_region
}

# Par de claves SSH para acceder a la instancia
resource "aws_key_pair" "default" {
  key_name = "key-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  public_key = var.inline_public_key
}

# Definición de la instancia EC2
resource "aws_instance" "app" {
  ami           = var.ami_id                              # ID de la AMI (Ubuntu 22.04 por defecto)
  instance_type = var.instance_type                       # Tipo de instancia (t2.micro por defecto)
  key_name      = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "interaction-sites-instance"                   # Nombre de la instancia en consola AWS
  }
}

# Grupo de seguridad para controlar el tráfico de red
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Permite acceso SSH, HTTP y HTTPS"

  # Regla para permitir conexiones SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla para permitir tráfico HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla para permitir tráfico HTTPS
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla para permitir todo el tráfico saliente
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "interaction-sites-sg"   # Nombre del grupo de seguridad en consola AWS
  }
}