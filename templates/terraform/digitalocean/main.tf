# ========================================================
# TEMPLATE DE TERRAFORM PARA DIGITAL OCEAN
# Descripción: Crea una instancia Droplet con un firewall configurado
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
  name   = "app"                       # Nombre del Droplet
  region = "nyc3"                      # Región donde se creará (Nueva York 3)
  size   = "s-1vcpu-1gb"               # Tamaño del Droplet (1 vCPU, 1GB RAM, elegible para prueba gratuita)
  image  = "ubuntu-22-04-x64"          # Imagen del sistema operativo (Ubuntu 22.04 LTS)
  ssh_keys = [var.inline_public_key]   # ID de la clave SSH que se usará para acceder

  tags = ["app-droplet"]               # Etiquetas para organizar recursos
}

# Crear firewall para el Droplet
resource "digitalocean_firewall" "app_firewall" {
  name = "app-firewall"

  # Reglas de entrada (inbound)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"               # SSH
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"               # HTTP
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"              # HTTPS
    source_addresses = ["0.0.0.0/0"]
  }

  # Reglas de salida (outbound)
  outbound_rule {
    protocol              = "tcp"
    port_range            = "0"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "0"
    destination_addresses = ["0.0.0.0/0"]
  }

  # Asignar el firewall al Droplet
  droplet_ids = [digitalocean_droplet.app.id]
}

# INSTRUCCIONES
# 1. REQUISITOS
#    - Cuenta de DigitalOcean activa
#    - Token de API de DigitalOcean con permisos adecuados
#    - Par de claves generadas en tu máquina local
#    - La clave publica se añade en SSH Keys de DigitalOcean
#    - En GitHub Actions se requiere tener definidos los secretos correspondientes.
#
# 2. PERSONALIZACIÓN
#    - Nombre y Tags: Modifica el nombre del Droplet y los tags según tu proyecto
#    - Región: Cambia "nyc3" por otra región de DigitalOcean si prefieres otro centro de datos
#    - Tamaño: Modifica "s-1vcpu-1gb" por otro tamaño si necesitas más recursos
#    - Imagen: Por defecto usa Ubuntu 22.04, puedes cambiarla según tus necesidades
#    - Puertos: Añade más reglas 'inbound_rule' para abrir puertos adicionales
#
# 3. SEGURIDAD IMPORTANTE
#    - La configuración actual permite acceso SSH desde cualquier IP (0.0.0.0/0)
#      Después de la creación, restringe el acceso SSH por seguridad (solo si no usaras GitHub Actions)
#    - Los puertos 80 y 443 están abiertos para permitir tráfico web
#
# 4. WORKFLOW DE GITHUB ACTIONS
#    - Este template está diseñado para funcionar con el workflow terraform-ansible.yml
#    - Después de crear la infraestructura, el workflow usa Ansible para configurar el Droplet
#
# 5. OUTPUTS
#    - Al ejecutar Terraform, se mostrará:
#      * instance_public_ip: La IP pública para conectarte al Droplet
#
# NOTA:
# - Los Droplets de tamaño s-1vcpu-1gb son los más económicos pero tienen recursos limitados
#   Considera aumentar el tamaño para aplicaciones en producción o que requieran más recursos
