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