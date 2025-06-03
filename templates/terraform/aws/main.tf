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
  ami           = var.ami_id            # ID de la AMI (Ubuntu 22.04 por defecto)
  instance_type = var.instance_type     # Tipo de instancia (t2.micro por defecto)
  key_name      = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "apicore-gm-client-instance"           # Nombre de la instancia en consola AWS
  }
}

# Elastic IP (comentada por defecto)
# Descomenta este bloque si necesitas una IP fija para asociar con un dominio (aumenta el costo)
/*
resource "aws_eip" "app_eip" {
  instance = aws_instance.app.id
  domain   = "vpc"
  
  tags = {
    Name = "appname-eip"
  }
}
*/

# Grupo de seguridad para controlar el tráfico de red
resource "aws_security_group" "app_sg" {
  name        = "apicore-gm-client-security-group"
  description = "Allow SSH, HTTP and HTTPS access"

  # Regla para permitir conexiones SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]         # Esto es necesario para conectarse con GitHub Actions, despues se debe restringir manualmente.
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
    Name = "apicore-gm-client-sg"   # Nombre del grupo de seguridad en consola AWS
  }
}

# INSTRUCCIONES
# 1. REQUISITOS
#    - Cuenta de AWS con permisos para crear recursos
#    - AWS Access Key y Secret Key con permisos adecuados
#    - Par de claves SSH generado (para acceder a la instancia)
#    - En GitHub Actions se requiere tener definidos los secretos correspondientes.
#
# 2. PERSONALIZACIÓN
#    - Tags: Modifica los tags de la instancia y el grupo de seguridad según los nombres que tu quieras.
#    - Región AWS, Tipo de instancia, y AMI: Modifica en variables.tf para elegir los recursos que prefieras.
#    - Puertos: Añade más reglas 'ingress' para abrir puertos adicionales
#    - Elastic IP: Descomenta el bloque aws_eip si necesitas una IP fija para tu instancia.
#                  Puedes asociar un dominio personalizado con la Elastic IP si lo deseas, verifica la sección de variables.
#
# 3. SEGURIDAD IMPORTANTE
#    - Se requiere cidr_blocks = ["0.0.0.0/0"] para conectarse con SSH a GitHub Actions.
#      Después de la creación, restringe el acceso SSH a tu IP específica o elimina la regla manualmente.
#
# 4. WORKFLOW DE GITHUB ACTIONS
#    - Este template está diseñado para funcionar con el workflow terraform-ansible.yml
#    - El workflow proporciona la variable inline_public_key automáticamente
#    - Después de crear la infraestructura, el workflow usa Ansible para configurar la instancia
#
# 5. OUTPUTS
#    - Al ejecutar Terraform, se mostrarán:
#      * instance_public_ip: La IP pública para conectarte a la instancia
#      * key_pair_name: El nombre del key pair creado en AWS
