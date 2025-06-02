# ========================================================
# VARIABLES PARA TERRAFORM
# Descripción: Define los parámetros configurables para el despliegue
# ========================================================

# Región de AWS donde se crearán los recursos
variable "aws_region" {
  description = "AWS region for all resources"
  default = "us-east-1"
}

# ID de la AMI (Amazon Machine Image) para la instancia
variable "ami_id" {
  description = "Ubuntu 22.04 LTS AMI (Free Tier)"
  default     = "ami-053b0d53c279acc90"
}

# Tipo de instancia EC2 (t2.micro es elegible para capa gratuita)
variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default = "t2.micro"
}

# Clave pública SSH para acceder a la instancia
# Se pasa como variable de entorno o mediante el workflow
variable "inline_public_key" {
  description = "Public SSH key inline"
  type        = string
}
