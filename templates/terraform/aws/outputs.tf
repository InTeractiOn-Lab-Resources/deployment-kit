# ========================================================
# OUTPUTS DE TERRAFORM
# Descripción: Define los valores que se mostrarán al finalizar la ejecución
# y que pueden ser utilizados por otros sistemas (como Ansible)
# ========================================================

# La dirección IP pública de la instancia creada
output "instance_public_ip" {
  description = "IP pública de la instancia EC2 creada"
  value       = aws_instance.app.public_ip
}

# El nombre del key pair creado en AWS
output "key_pair_name" {
  description = "Nombre del key pair creado en AWS"
  value = aws_key_pair.default.key_name
}
