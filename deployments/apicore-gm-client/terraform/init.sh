#!/bin/bash
# ========================================================
# SCRIPT DE INICIALIZACIÓN
# Descripción: Configura la instancia EC2 al inicio
# ========================================================

# Actualizar el sistema
apt-get update
apt-get upgrade -y

# Instalar dependencias básicas
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git

# Configurar zona horaria
timedatectl set-timezone UTC

# Configurar un mensaje de bienvenida
echo "Instancia configurada por Terraform - $(date)" > /etc/motd

echo "Inicialización completada: $(date)" >> /var/log/init-script.log
