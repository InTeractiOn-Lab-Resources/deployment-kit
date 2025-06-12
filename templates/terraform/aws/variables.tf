# ========================================================
# VARIABLES PARA TERRAFORM
# Descripción: Define los parámetros configurables para el despliegue
# ========================================================

# Región de AWS donde se crearán los recursos
variable "aws_region" {
  description = "AWS region donde se desplegarán los recursos"
  default = "us-east-1"
}

# ID de la AMI (Amazon Machine Image) para la instancia
variable "ami_id" {
  description = "Ubuntu 22.04 LTS AMI (Free Tier)"
  default     = "ami-053b0d53c279acc90"
}

# Tipo de instancia EC2 (t2.micro es elegible para capa gratuita)
variable "instance_type" {
  description = "Tipo de instancia EC2"
  default = "t2.micro"
}

# Clave pública SSH para acceder a la instancia
# Se pasa como variable de entorno o mediante el workflow
variable "inline_public_key" {
  description = "Clave pública SSH para acceder a la instancia"
  type        = string
}

# NOTA:
# - Modificar Región AWS, Tipo de instancia, y AMI según las necesidades del proyecto.
#   Por defecto, se utiliza una AMI de Ubuntu 22.04 LTS y una instancia t2.micro apta para la capa gratuita de AWS.
