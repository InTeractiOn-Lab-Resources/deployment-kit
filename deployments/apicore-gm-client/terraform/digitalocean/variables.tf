# ========================================================
# VARIABLES PARA TERRAFORM
# Descripción: Define los parámetros configurables para el despliegue
# ========================================================

# Token de DigitalOcean (pasado desde GitHub Actions)
variable "do_token" {
  description = "Token de acceso a DigitalOcean"
  type        = string
}

# Huella digital (fingerprint) de la clave SSH en DigitalOcean
variable "inline_public_key" {
  description = "Fingerprint de la clave SSH en DigitalOcean"
  type        = string
}
