# ========================================================
# VARIABLES DE CONFIGURACIÓN
# Descripción: Define las variables configurables para la infraestructura
# ========================================================

# Región de AWS donde se desplegará la infraestructura
variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"  # Cambia esto según tu región preferida
}

# AMI a utilizar para la instancia EC2
variable "ami_id" {
  description = "ID de la AMI a utilizar (por defecto: Ubuntu 22.04 LTS)"
  type        = string
  default     = "ami-053b0d53c279acc90"  # Ubuntu 22.04 LTS en us-east-1
  # NOTA: Las AMIs varían por región. Actualiza este valor según tu región:
  # - us-west-2: ami-03f65b8614a860c29
  # - eu-west-1: ami-0694d931cee176e7d
}

# Tipo de instancia EC2
variable "instance_type" {
  description = "Tipo de instancia EC2 (t2.micro es elegible para capa gratuita)"
  type        = string
  default     = "t2.micro"
}

# Clave SSH pública para acceso a la instancia
variable "inline_public_key" {
  description = "Clave SSH pública para acceder a la instancia"
  type        = string
}

# Nombre base para los recursos (prefijo)
variable "name_prefix" {
  description = "Prefijo para nombrar los recursos creados"
  type        = string
  default     = "app"
}

# Etiquetas para los recursos
variable "tags" {
  description = "Etiquetas para aplicar a los recursos"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "microservices-app"
    ManagedBy   = "terraform"
  }
}

# Puertos a abrir en el Security Group
variable "ingress_ports" {
  description = "Lista de puertos a abrir en el security group"
  type        = list(number)
  default     = [80, 443]
}

# Configuración de disco EBS
variable "ebs_volume_size" {
  description = "Tamaño del volumen EBS en GB"
  type        = number
  default     = 8  # 8GB por defecto, ajusta según necesidades
}

# CIDR para acceso SSH (por seguridad, es mejor restringir)
variable "ssh_cidr_blocks" {
  description = "CIDR blocks para acceso SSH (por seguridad, limita a tu IP)"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Permite acceso desde cualquier IP (no recomendado para producción)
}
