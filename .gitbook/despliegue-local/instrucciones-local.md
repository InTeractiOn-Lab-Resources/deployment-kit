---
icon: book-open
---

# Instrucciones local

Para el despliegue local se utilizará **únicamente el template de Ansible** incluido en el repositorio [deployment-kit](https://github.com/infra-sandbox/deployment-kit). Este despliegue está pensado para ejecutarse directamente desde tu máquina con **Ubuntu**.

## Prerrequisitos

Asegúrate de tener lo siguiente en tu máquina local:

* Ubuntu (recomendado Ubuntu 20.04+)
* Ansible (`sudo apt install ansible`)
* Git (`sudo apt install git`)

## Pasos para desplegar

{% stepper %}
{% step %}
### **Copia el template de Ansible**

Ve al repositorio [deployment-kit](https://github.com/infra-sandbox/deployment-kit) e ingresa a la carpeta `templates`.

Copia la carpeta `ansible` en tu repositorio, dentro del directorio de despliegue.
{% endstep %}

{% step %}
### **Configura el template**

Revisa la sección [Configuración](configuracion-local/) para adaptar los archivos a tu proyecto.

{% hint style="info" %}
Si necesitas ejemplos de cómo pueden ser configuradas las plantillas, puedes revisar el directorio [deployments](https://github.com/infra-sandbox/deployment-kit/tree/main/deployments) dentro del repositorio [deployment-kit](https://github.com/infra-sandbox/deployment-kit). Ahí encontrarás aplicaciones reales donde se han aplicado las plantillas.
{% endhint %}
{% endstep %}

{% step %}
### **Clona el repositorio de trabajo en tu máquina local**

Una vez que hayas realizado el commit con tu configuración adaptada, clona el repositorio en la máquina donde se realizará el despliegue.

```bash
git clone https://github.com/tu-org/tu-repo.git
```
{% endstep %}

{% step %}
### **Copia el directorio de despliegue a una ubicación ordenada**

Para mantener una estructura limpia y evitar errores, se recomienda copiar el directorio de despliegue **fuera del repositorio principal**, por ejemplo al `home` de la máquina.

```bash
sudo cp -r ~/tu-repo/directorio_de_despliegue/ ~/
```

{% hint style="info" %}
Esta práctica es altamente recomendada cuando no usas imágenes Docker preconstruidas (Docker Hub), y necesitas clonar los repositorios y construir las imágenes localmente. Esto evita tener **repositorios dentro de otros repositorios**, lo cual puede generar problemas de gestión y rutas incorrectas.
{% endhint %}
{% endstep %}

{% step %}
### Ingresa al directorio de despliegue

```bash
cd ~/directorio_de_despliegue
```
{% endstep %}

{% step %}
### **Crea el archivo `.env`**

Crea el arhivo .env dentro de tu directorio principal de despliegue y define las variables necesarias.

```bash
touch .env
nano .env
```

Si existe el archivo `.env.example` en el directorio de despliegue, puedes correr los siguientes comandos para definir las variables que necesites.

```bash
cp .env.example .env
nano .env
```

{% hint style="danger" %}
Si usas **clonar repositorios como modo de despliegue**, asegúrate de que las rutas en tu archivo `.env` coincidan con el path real, es decir: `APP_PATH: /home/usuario/directorio_de_despliegue/app`.

[Ver ejemplo de archivo .env](https://github.com/infra-sandbox/deployment-kit/blob/main/deployments/apicore-gm-client/.env.example)
{% endhint %}
{% endstep %}

{% step %}
### **Ejecuta el playbook de Ansible**

```bash
sudo ANSIBLE_ROLES_PATH=ansible/roles ansible-playbook ansible/playbooks/deploy_diinf.yml -i ansible/inventory/hosts.ini
```
{% endstep %}
{% endstepper %}

{% hint style="success" %}
Si todo ha funcionado correctamente, deberías poder acceder a tu aplicación desde el navegador en la dirección correspondiente (por ejemplo: `http://localhost:8080` o la que hayas configurado).
{% endhint %}
