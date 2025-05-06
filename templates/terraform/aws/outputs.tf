# ========================================================
# SALIDAS DE TERRAFORM
# Descripción: Define las salidas que serán mostradas después de la creación
# ========================================================

output "instance_id" {
  description = "ID de la instancia EC2 creada"
  value       = aws_instance.app_instance.id
}

output "instance_public_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = aws_instance.app_instance.public_ip
}

output "instance_private_ip" {
  description = "Dirección IP privada de la instancia EC2"
  value       = aws_instance.app_instance.private_ip
}

output "key_pair_name" {
  description = "Nombre del par de claves creado en AWS (usado para SSH)"
  value       = aws_key_pair.app_key.key_name
}

output "security_group_id" {
  description = "ID del grupo de seguridad creado"
  value       = aws_security_group.app_sg.id
}

output "ssh_command" {
  description = "Comando para conectarse a la instancia via SSH"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.app_instance.public_ip}"
}

# Información de conexión para Ansible
output "ansible_inventory" {
  description = "Línea para añadir al inventario de Ansible"
  value       = "${var.name_prefix}-instance ansible_host=${aws_instance.app_instance.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa"
}
