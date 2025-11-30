# Workflow Terraform-Ansible

Este workflow de GitHub Actions permite **automatizar por completo el proceso de despliegue de tu aplicación en la nube**, ya sea sobre una instancia EC2 (AWS) o un Droplet (DigitalOcean).

GitHub Actions es una herramienta de **integración y entrega continua** (CI/CD) integrada en GitHub. Permite definir flujos de trabajo que se ejecutan automáticamente cuando ocurren ciertos eventos en tu repositorio o mediante una ejecución manual.&#x20;

En este caso, se utiliza para coordinar la ejecución de **Terraform** y **Ansible** como parte de un pipeline de despliegue automatizado.&#x20;

El código se divide en dos trabajos:

* `create-infrastructure`: Crea la infraestructura usando Terraform.
* `provision-instance`: Configura automáticamente la instancia con Ansible, desplegando la aplicación.

## Estructura

Asegúrate de tener la siguiente estructura dentro de tu repositorio:

```
/.github/
└── workflows/
    └── terraform-ansible.yml

/{directorio_principal_de_despliegue}/
├── docker-compose.yml
├── .env
├── ansible/
│   ├── inventory/
│   ├── playbooks/
│   └── roles/
├── terraform/
│   ├── aws/
│   └── digitalocean/
```

## Instrucciones

<details>

<summary>Define tu directorio principal de despliegue</summary>

En la sección `deployment_dir` del workflow, asegúrate de especificar correctamente el nombre del directorio donde se encuentra tus archivos de despliegue (por ejemplo: `deployment/`, `deploy/`, etc.).

```yaml
on:
  workflow_dispatch:
    inputs:
      deployment_dir:
        description: 'Directorio principal de despliegue'
        required: true
        default: 'deployment' # Cambia esto si usas otro nombre de carpeta
```

</details>

<details>

<summary>Define el directorio de terraform</summary>

Dentro de la sección de trabajos del workflow `jobs`, ubica el primer trabajo llamado `create-infrastructure`. En la sección `defaults`, encontrarás la propiedad `working-directory`, que indica la ruta donde se encuentran los archivos de Terraform.

Debes establecer esta ruta según el proveedor que estés utilizando:

Para **DigitalOcean**, utiliza:

```yaml
working-directory: ${{ github.event.inputs.deployment_dir }}/terraform/digitalocean
```

Para **AWS**, utiliza:

```yaml
working-directory: ${{ github.event.inputs.deployment_dir }}/terraform/aws
```

{% hint style="info" %}
Si estás utilizando una ruta personalizada distinta a la de los templates, recuerda actualizar `working-directory` con la ruta correcta según tu estructura.
{% endhint %}

</details>

<details>

<summary>Define las variables para tus secretos</summary>

Como se explicó en la sección de [instrucciones](../instrucciones-cloud.md), ya configuraste los secretos necesarios en GitHub. Ahora, según el proveedor que estés utilizando, debes referenciar correctamente las variables correspondientes a esos secretos, y eliminar las que no apliquen a tu caso.

Para ello, dirígete a la sección de trabajos del workflow `jobs` y localiza el trabajo `create-infrastructure`.&#x20;

Dentro de su bloque `env`, define las variables necesarias para tu proveedor:

Para **DigitalOcean**, utiliza las variables:

```yaml
TF_VAR_do_token: ${{ secrets.DO_TOKEN }}
TF_VAR_inline_public_key: ${{ secrets.DO_INLINE_PUBLIC_KEY }}
```

Para **AWS**, utiliza las variables:

```yaml
AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
TF_VAR_inline_public_key: ${{ secrets.AWS_INLINE_PUBLIC_KEY }}
```

{% hint style="info" %}
Recuerda que solo debes mantener las variables que vayas a utilizar. Si mezclas variables de diferentes proveedores, el despliegue podría fallar.
{% endhint %}

</details>

<details>

<summary>Define el usuario SSH para la instancia</summary>

En la sección de trabajos del workflow `jobs`, localiza el segundo trabajo llamado `provision-instance`. Dentro de su bloque `env`, debes definir qué usuario se utilizará para acceder por SSH a la instancia.

Este usuario varía según el proveedor de infraestructura:

Para **DigitalOcean**, el usuario por defecto es:

```yaml
SSH_USER: root
```

Para **AWS**, el usuario por defecto es:

```yaml
SSH_USER: ubuntu
```

</details>

<details>

<summary>Define las variables de entorno que se inyectarán en Ansible</summary>

En la sección `jobs` del workflow, localiza el segundo trabajo llamado `provision-instance`.\
Dentro de su bloque `steps`, dirígete al **paso 4** llamado **"Run Ansible Playbook"**.

En este paso se genera dinámicamente un archivo llamado `vars.yml`, que contiene las variables de entorno que serán inyectadas automáticamente en Ansible.\
Estas variables permiten configurar rutas y servicios de forma automática y generar correctamente el archivo `.env` necesario para Docker Compose.

Agrega en ese archivo únicamente las variables que realmente necesites:

```yaml
# Variables de entorno (Modificar según tus secretos, esto es un ejemplo)
postgres_user: ${{ secrets.POSTGRES_USER }}
postgres_password: ${{ secrets.POSTGRES_PASSWORD }}
postgres_db: ${{ secrets.POSTGRES_DB }}
mongo_username: ${{ secrets.MONGO_USERNAME }}
mongo_password: ${{ secrets.MONGO_PASSWORD }}
```

{% hint style="warning" %}
Esta configuración es opcional. Solo debes incluir variables aquí si tienes valores sensibles definidos como secretos y necesitas que Ansible los utilice durante el despliegue.

**Si no vas a usar variables de entorno como secretos**, **puedes eliminar este bloque** sin afectar el funcionamiento del pipeline.
{% endhint %}

{% hint style="danger" %}
Las variables que declares aquí deben estar también referenciadas en el playbook de Ansible,\
tal como se explica en la sección de [configuración de Ansible](ansible-cloud.md).
{% endhint %}

</details>
