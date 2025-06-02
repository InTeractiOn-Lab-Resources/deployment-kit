# ========================================================
# TEMPLATE DE TERRAFORM PARA AWS
# Descripción: Crea una instancia EC2 con grupo de seguridad configurado
# ========================================================

# Configuración del proveedor AWS - Define la región donde se crearán los recursos
provider "aws" {
  region = var.aws_region
}

# Par de claves SSH para acceder a la instancia
# El key_name debe ser único para evitar colisiones
resource "aws_key_pair" "default" {
  key_name = "key-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  public_key = var.inline_public_key
}

# Definición de la instancia EC2
resource "aws_instance" "sandbox" {
  ami           = var.ami_id            # ID de la AMI (Ubuntu 22.04 por defecto)
  instance_type = var.instance_type     # Tipo de instancia (t2.micro por defecto)
  key_name      = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.sandbox_sg.id]

  tags = {
    Name = "apicore-gm-client-instance"           # Nombre visible en la consola AWS
  }
}

# Grupo de seguridad para controlar el tráfico de red
resource "aws_security_group" "sandbox_sg" {
  name        = "apicore-gm-client-security-group"
  description = "Allow SSH and HTTP access"

  # Regla para permitir conexiones SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]         # Por seguridad, restringe a tu IP en producción
  }

  # Regla para permitir tráfico HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "apicore-gm-client-sg"
  }
}

# INSTRUCCIONES
# 1. REQUISITOS
#    - Cuenta de AWS con permisos para crear recursos
#    - AWS Access Key y Secret Key con permisos adecuados
#    - Par de claves SSH generado (para acceder a la instancia)

# 2. PERSONALIZACIÓN
#    - Región AWS: Modifica var.aws_region en variables.tf para elegir tu región preferida
#    - Tipo de instancia: Cambia var.instance_type si necesitas más potencia
#    - AMI: Actualiza var.ami_id si deseas otra versión de Ubuntu u otro sistema operativo
#    - Puertos: Añade más reglas 'ingress' en main.tf para abrir puertos adicionales

# 3. SEGURIDAD IMPORTANTE
#    - En entornos de producción, NUNCA uses cidr_blocks = ["0.0.0.0/0"] para SSH
#    - Reemplaza con tu IP específica, por ejemplo: cidr_blocks = ["123.123.123.123/32"]
#    - Considera usar una VPC privada con un balanceador de carga para aplicaciones públicas

# 4. WORKFLOW DE GITHUB ACTIONS
#    - Este template está diseñado para funcionar con el workflow terraform-ansible.yml
#    - El workflow proporciona la variable inline_public_key automáticamente
#    - Después de crear la infraestructura, el workflow usa Ansible para configurar la instancia

# 5. OUTPUTS
#    - Al ejecutar Terraform, se mostrarán:
#      * instance_public_ip: La IP pública para conectarte a la instancia
#      * key_pair_name: El nombre del key pair creado en AWS
