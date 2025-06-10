# ========================================================
# OUTPUTS DE TERRAFORM
# Descripción: Define los valores que se mostrarán al finalizar la ejecución
# y que pueden ser utilizados por otros sistemas (como Ansible)
# ========================================================

output "instance_public_ip" {
  description = "IP pública de la droplet creada"
  value       = digitalocean_droplet.app.ipv4_address
}

output "droplet_name" {
  description = "Nombre de la droplet creada"
  value       = digitalocean_droplet.app.name
}
