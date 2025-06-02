# ========================================================
# CONFIGURACIÓN PRINCIPAL DE TERRAFORM
# Descripción: Define los recursos principales de la infraestructura
# ========================================================

# Configuración del proveedor AWS
provider "aws" {
  region = var.aws_region
}

# Par de claves para acceso SSH a la instancia
resource "aws_key_pair" "app_key" {
  key_name   = "${var.name_prefix}-key-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  public_key = var.inline_public_key
  tags       = var.tags
}

# Security Group para la instancia
resource "aws_security_group" "app_sg" {
  name        = "${var.name_prefix}-sg"
  description = "Security Group para aplicación de microservicios"
  
  # Regla para SSH (restringida a CIDRs especificados)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }
  
  # Reglas dinámicas para los puertos definidos en variables
  dynamic "ingress" {
    for_each = [for port in var.ingress_ports : port if port != 22]
    content {
      description = "Puerto ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Permitir todo el tráfico saliente
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-security-group"
    }
  )
}

# Instancia EC2
resource "aws_instance" "app_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.app_key.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  
  root_block_device {
    volume_size = var.ebs_volume_size
    volume_type = "gp2"
    encrypted   = true
    tags        = var.tags
  }

  # Script opcional de inicialización
  user_data = file("${path.module}/scripts/init.sh")
  
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-instance"
    }
  )

  # Crear directorio para la aplicación
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ubuntu/app"
    ]
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")  # Ajusta la ruta a tu clave privada
      host        = self.public_ip
    }
  }

  depends_on = [
    aws_security_group.app_sg
  ]
}

# Opción: Crear una IP elástica (comentada por defecto)
# Para habilitar, quita los símbolos de comentario /* */
/*
resource "aws_eip" "app_eip" {
  domain   = "vpc"
  instance = aws_instance.app_instance.id
  tags     = var.tags
}
*/
