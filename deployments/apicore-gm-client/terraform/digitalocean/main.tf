# ========================================================
# TEMPLATE DE TERRAFORM PARA DIGITAL OCEAN
# Descripción: Crea una instancia Droplet con grupo de seguridad configurado
# ========================================================

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configura el proveedor de DigitalOcean con el token de autenticación
provider "digitalocean" {
  token = var.do_token
}

# Define un Droplet
resource "digitalocean_droplet" "app" {
  name   = "apicore-gm-client"         # Nombre del Droplet
  region = "nyc3"                      # Región donde se creará (Nueva York 3)
  size   = "s-1vcpu-1gb"               # Tamaño del Droplet (1 vCPU, 1GB RAM, elegible para prueba gratuita)
  image  = "ubuntu-22-04-x64"          # Imagen del sistema operativo (Ubuntu 22.04 LTS)
  ssh_keys = [var.inline_public_key]   # ID de la clave SSH que se usará para acceder

  tags = ["apicore-gm-client-droplet"] # Etiquetas para organizar recursos
  
  # Script de inicialización para montar automáticamente el volumen y pre-instalar dependencias
  user_data = <<-EOF
    #!/bin/bash
    
    # Desactivar actualizaciones automáticas para evitar conflictos con apt
    systemctl stop unattended-upgrades 2>/dev/null || true
    systemctl disable unattended-upgrades 2>/dev/null || true
    
    # Pre-instalar dependencias necesarias para Ansible
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y python3 python3-pip docker.io docker-compose curl gnupg ca-certificates
    
    # Esperar a que el volumen esté disponible
    while [ ! -e /dev/disk/by-id/scsi-0DO_Volume_app-data ]; do
      echo "Esperando a que el volumen esté disponible..."
      sleep 5
    done
    
    # Crear directorio para montar el volumen
    mkdir -p /data
    
    # Montar el volumen con opciones optimizadas
    mount -o discard,defaults /dev/disk/by-id/scsi-0DO_Volume_app-data /data
    
    # Configurar el montaje automático después de reinicios
    echo '/dev/disk/by-id/scsi-0DO_Volume_app-data /data ext4 defaults,nofail,discard 0 2' >> /etc/fstab
    
    # Configurar directorios para Docker
    mkdir -p /data/mongo /data/postgres
    chmod 777 /data/mongo /data/postgres
    
    # Crear un archivo para verificar que el script se ejecutó
    echo "Volumen montado correctamente el $(date)" > /data/volume_mounted.txt
    echo "Dependencias pre-instaladas: Python3, Docker, etc." >> /data/volume_mounted.txt
  EOF
}

# Crear un volumen para datos persistentes
resource "digitalocean_volume" "app_data" {
  region                  = "nyc3"                # Debe coincidir con la región del Droplet
  name                    = "app-data"            # Nombre del volumen
  size                    = 10                    # Tamaño en GB
  initial_filesystem_type = "ext4"                # Formato inicial (DigitalOcean lo formatea automáticamente)
  description             = "Volumen para datos de la aplicación"
}

# Adjuntar el volumen al Droplet
resource "digitalocean_volume_attachment" "app_data_attachment" {
  droplet_id = digitalocean_droplet.app.id
  volume_id  = digitalocean_volume.app_data.id
}

# Definir un firewall para el Droplet
resource "digitalocean_firewall" "app_firewall" {
  name = "apicore-gm-client-firewall"
  
  # Regla para permitir SSH
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }
  
  # Regla para permitir HTTP
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }
  
  # Regla para permitir HTTPS
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }
  
  # Aplicar este firewall al Droplet
  droplet_ids = [digitalocean_droplet.app.id]
}
