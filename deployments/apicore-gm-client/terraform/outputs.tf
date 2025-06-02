# ========================================================
# OUTPUTS DE TERRAFORM
# Descripción: Define los valores que se mostrarán al finalizar la ejecución
# y que pueden ser utilizados por otros sistemas (como Ansible)
# ========================================================

# La dirección IP pública de la instancia creada
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app.public_ip
}

# El nombre del key pair creado en AWS
output "key_pair_name" {
  description = "Name of the key pair created in AWS (used to SSH into the instance)"
  value = aws_key_pair.default.key_name
}
