# Deployment Kit

Este repositorio contiene un conjunto de **plantillas y scripts de despliegue** diseñadas para levantar los servicios y aplicaciones cloud del laboratorio InTeractiOn.

## Objetivo
Crear un kit de plantillas de despliegue que pueda:
- Estandarizar el proceso de despliegue del laboratorio.
- Agilizar y reducir tiempos de puesta en marcha.
- Adaptarse fácilmente a distintos entornos (local, cloud y máquinas virtuales).
- Ser utilizado por otros miembros o tesistas del laboratorio InTeractiOn.

## Estructura del repositorio

- **`templates/`**: Contiene plantillas para producción o staging, listas para ser reutilizadas.
- **`deployments/`**: Incluye ejemplos concretos de despliegue de aplicaciones usando las plantillas. Cada carpeta muestra cómo se personalizó un template para un caso real, con scripts listos para ejecutar. Puedes usarlos como referencia o punto de partida para tus propios despliegues.

## Documentación

Toda la documentación detallada de uso del Deployment Kit está disponible en el siguiente enlace:

[**Acceder a la documentación en GitBook**](https://infra-sandbox.gitbook.io/deployment-kit-docs)

## Tecnologías

- **Ansible** – Automatización de configuración y despliegue.
- **Terraform** – Provisionamiento de infraestructura como código (IaC).
- **Docker / Docker Compose** – Contenerización y orquestación local.
- **Nginx** – Manejo de tráfico y reverse proxy entre servicios.
- **GitHub Actions** – Automatización CI/CD desde repositorios.

## Proyecto de tesis asociado

**Título:**  
_Estandarización del proceso de despliegue para los servicios y aplicaciones cloud del laboratorio InTeractiOn_

**Autora:**  
Carolina Antillanca Hidalgo  
Memorista - Departamento de Informática  
Universidad de Santiago de Chile

## Licencia y uso

Las plantillas de este repositorios pueden ser reutilizadas o adaptadas por otros miembros del laboratorio InTeractiOn que busquen automatizar el proceso de despliegue en distintos entornos.
