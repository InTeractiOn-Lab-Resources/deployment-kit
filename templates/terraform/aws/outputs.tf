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

/*
# IP Elástica asignada (solo si está habilitada)
output "elastic_ip" {
  description = "Elastic IP asignada a la instancia"
  value       = aws_eip.app_eip.public_ip
  depends_on = [aws_eip.app_eip]
}

# Dominio configurado (si se especificó)
output "domain_name" {
  description = "Dominio asociado con la Elastic IP"
  value       = var.domain_name != "" ? var.domain_name : "No domain configured"
}
*/

# NOTA:
# Descomentar los bloques de Elastic IP y dominio si se necesita una IP fija y un dominio personalizado.
# De lo contrario, no se modifica este archivo y los bloques se mantienen comentados.
