---
icon: gear
---

# Configuración DIINF

En esta sección encontrarás cómo configurar los templates necesarios para realizar el **despliegue en el entorno DIINF**.

Para este entorno, solo se requiere configurar el template de Ansible:

{% content-ref url="ansible-diinf.md" %}
[ansible-diinf.md](ansible-diinf.md)
{% endcontent-ref %}

## ¿Cómo funciona Ansible para el despliegue?

Ansible se encarga de preparar automáticamente el entorno necesario y levantar los servicios para que tu aplicación funcione correctamente en la máquina virtual. Entre sus tareas principales se incluyen:

* Instalación de dependencias esenciales, como Python y Docker.
* Configuración del firewall, permitiendo tráfico HTTP y HTTPS (puertos 80 y 443).
* Generación y configuración automática de certificados SSL mediante **Certbot**, si se usan dominios.
* Despliegue de tus servicios en función del **modo seleccionado** (uso de imágenes preconstruidas o clonación de repositorios).
* Configuración del **proxy inverso con Nginx**, adaptado a los servicios definidos.
