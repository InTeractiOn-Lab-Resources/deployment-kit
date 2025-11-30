---
icon: bullseye-arrow
cover: >-
  https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?crop=entropy&cs=srgb&fm=jpg&ixid=M3wxOTcwMjR8MHwxfHNlYXJjaHw5fHx0ZW1wbGF0ZXN8ZW58MHx8fHwxNzQ1ODkwMTkyfDA&ixlib=rb-4.0.3&q=85
coverY: 0
---

# Quickstart

## Estructura de trabajo

Para comenzar a trabajar con estas plantillas, debes crear un **directorio principal de despliegue** donde agregaras todos los archivos necesarios para este proceso.&#x20;

Este directorio debe estar ubicado **dentro de un repositorio** y será el **punto de partida desde donde se ejecutarán los despliegues**.

Asegúrate de mantener esta estructura, ya que todo el proceso automatizado dependerá de este punto central.

## ¿Que necesitas para comenzar?

### **Plantillas de despliegue**

Dirígete al repositorio [deployment-kit](https://github.com/infra-sandbox/deployment-kit) y revisa las plantillas disponibles dentro de la carpeta `template`. Ahí encontrarás scripts listos para usar según el entorno de despliegue que necesites.

### **Archivos de configuración esenciales**

Dentro de la carpeta de despliegue, asegúrate de tener al menos:

* `docker-compose.yml`&#x20;
* Cualquier otro archivo necesario para tu entorno (`init.sql`, `.env.example`, etc)&#x20;

### **Modo de despliegue**

Las plantillas ofrecen **dos métodos de despliegue** para tus servicios:

*   **Mediante imágenes preconstruidas**

    Utiliza imágenes previamente construidas y **publicadas en Docker Hub**. Este método requiere que las imágenes estén disponibles públicamente con nombre y etiqueta.

{% hint style="info" %}
**¿No tienes CI configurado?** Aprende a subir tu aplicación a Docker Hub con el workflow [Docker Build and Push](../extras/docker-build-and-push.md).
{% endhint %}

*   **Clonación de repositorios y construcción local de imágenes**

    Esta opción clona los repositorios directamente desde GitHub y construye las imágenes dentro de la máquina o servidor. Los **repositorios deben ser públicos** para que Ansible pueda acceder a ellos.

{% hint style="success" %}
Además de esta guía, cada archivo principal de los templates incluye **instrucciones integradas al final del código**. Estas funcionan como una referencia rápida para ayudarte a comprender y aplicar correctamente cada template desde su propio archivo.
{% endhint %}

### Métodos de despliegue disponibles

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-cover data-type="files"></th><th data-hidden></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Despliegue Local</strong></td><td>Despliega localmente desde tu máquina Ubuntu.</td><td><a href="../.gitbook/assets/computer-5078696_1280.jpg">computer-5078696_1280.jpg</a></td><td></td><td><a href="../despliegue-local/instrucciones-local.md">instrucciones-local.md</a></td></tr><tr><td><strong>Despliegue DIINF</strong></td><td>Despliega en las VMs del DIINF.</td><td><a href="../.gitbook/assets/93661623_10158857547794276_7319889883282014208_n-scaled.jpg">93661623_10158857547794276_7319889883282014208_n-scaled.jpg</a></td><td></td><td><a href="../despliegue-diinf/instrucciones-diinf.md">instrucciones-diinf.md</a></td></tr><tr><td><strong>Despliegue Cloud</strong></td><td>Despliega en la nube (AWS o DigitalOcean)</td><td><a href="../.gitbook/assets/andras-vas-Bd7gNnWJBkU-unsplash.jpg">andras-vas-Bd7gNnWJBkU-unsplash.jpg</a></td><td></td><td><a href="../despliegue-cloud/instrucciones-cloud.md">instrucciones-cloud.md</a></td></tr></tbody></table>
