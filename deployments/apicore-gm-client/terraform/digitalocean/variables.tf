# ========================================================
# VARIABLES PARA TERRAFORM
# Descripción: Define los parámetros configurables para el despliegue
# ========================================================

# Token de DigitalOcean (pasado desde GitHub Actions)
variable "do_token" {
  description = "Token de acceso a DigitalOcean"
  type        = string
}

# ID de clave pública SSH ya registrada en DigitalOcean
variable "inline_public_key" {
  description = "ID de la clave pública SSH en DigitalOcean"
  type        = string
}
