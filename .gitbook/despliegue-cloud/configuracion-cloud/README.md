---
icon: gear
---

# Configuración cloud

En esta sección encontrarás cómo configurar los templates necesarios para realizar el **despliegue en el entorno cloud**.

Para este entorno, debes configurar los siguientes templates:

{% content-ref url="terraform.md" %}
[terraform.md](terraform.md)
{% endcontent-ref %}

{% content-ref url="workflow-terraform-ansible.md" %}
[workflow-terraform-ansible.md](workflow-terraform-ansible.md)
{% endcontent-ref %}

{% content-ref url="ansible-cloud.md" %}
[ansible-cloud.md](ansible-cloud.md)
{% endcontent-ref %}

## ¿Cómo funciona el pipeline de despliegue cloud?

El pipeline está diseñado para automatizar completamente el proceso de despliegue de tu aplicación en la nube. Este flujo está compuesto por tres elementos clave:

* **Terraform** se encarga de crear la infraestructura mínima necesaria en la nube. Esto incluye una instancia de bajo costo que aplica a los planes gratuitos de AWS o DigitalOcean.
* **Ansible** toma el control una vez que la infraestructura ha sido creada. Su tarea es preparar el servidor: instalar dependencias, copiar archivos necesarios, configurar el entorno, levantar servicios como Nginx y dejar la aplicación lista para funcionar.
* **GitHub Actions** actúa como orquestador del pipeline. Desde el repositorio, ejecuta primero el script de Terraform y, si todo se despliega correctamente, lanza el playbook de Ansible automáticamente. Así, con un solo clic, la aplicación queda desplegada y operativa.
