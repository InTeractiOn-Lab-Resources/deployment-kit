---
icon: book-open
---

# Instrucciones cloud

Para el despliegue en la nube se utilizará los template de **Ansible, Terraform** y el workflow **terraform-ansible** incluido en el repositorio [deployment-kit](https://github.com/infra-sandbox/deployment-kit).&#x20;

Esta sección explica cómo desplegar automáticamente tu aplicación utilizando infraestructura en la nube, actualmente compatible tanto con **AWS** como con **DigitalOcean**.

El proceso está completamente automatizado mediante **GitHub Actions**, lo que permite una configuración flexible y reproducible según el proveedor que elijas.

## Prerrequisitos

Antes de comenzar, asegúrate de contar con lo siguiente:

* Cuenta de GitHub con acceso a GitHub Actions
* Cuenta en algún proveedor cloud compatible (AWS o DigitalOcean)
* Par de claves SSH para conexión remota (`.pem` y `.pub`)

{% hint style="info" %}
Para generar tu par de claves en **AWS**, consulta la documentación oficial sobre [cómo crear un par de claves para la instancia EC2](https://docs.aws.amazon.com/es_es/AWSEC2/latest/UserGuide/create-key-pairs.html).

Para generar tu par de claves en **DigitalOcean**, consulta la documentación oficial sobre [cómo crear claves SSH con OpenSSH en Linux](https://docs.digitalocean.com/products/droplets/how-to/add-ssh-keys/create-with-openssh/).
{% endhint %}

* Credenciales de acceso para el proveedor que utilizarás:
  * **Para AWS:** claves de acceso (`AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY`)
  * **Para DigitalOcean:** token de acceso personal (API)

{% hint style="info" %}
Para obtener tus claves de acceso en **AWS**, consulta la documentación oficial sobre [cómo crear las claves de acceso para el usuario raíz](https://docs.aws.amazon.com/es_es/IAM/latest/UserGuide/id_root-user_manage_add-key.html).

Para obtener tus claves de acceso en **DigitalOcean**, consulta la documentación oficial sobre  [cómo crear un token personal de acceso](https://docs.digitalocean.com/reference/api/create-personal-access-token/).
{% endhint %}

## Pasos para desplegar

{% stepper %}
{% step %}
### Crea secretos en GitHub Actions

Accede a tu repositorio y registra los siguientes secretos en:\
`Settings` **>** `Secrets and variables` **>** `Actions` **>** `New repository secret`

{% tabs %}
{% tab title="AWS" %}
Para AWS es necesario tener los siguientes secretos:

{% code fullWidth="false" %}
```yaml
AWS_ACCESS_KEY_ID: ID de clave de acceso (Access Key ID)
AWS_SECRET_ACCESS_KEY: Clave secreta (Secret Access Key)
AWS_INLINE_PUBLIC_KEY: Clave pública (.pub)
SSH_PRIVATE_KEY: Clave privada (.pem / sin extensión)
```
{% endcode %}
{% endtab %}

{% tab title="DigitalOcean" %}
Para DigitalOcean es necesario tener los siguientes secretos:

```yaml
DO_TOKEN: Token personal de la API DigitalOcean
DO_INLINE_PUBLIC_KEY: Fingerprint de tu clave pública (.pub)
SSH_PRIVATE_KEY: Clave privada (.pem / sin extensión)
```

{% hint style="danger" %}
Para añadir tu clave pública SSH y obtener su _fingerprint_, sigue la [guía oficial de DigitalOcean para añadir claves SSH](https://docs.digitalocean.com/platform/teams/how-to/upload-ssh-keys/).

Es importante que el secreto `DO_INLINE_PUBLIC_KEY` contenga el _fingerprint_, **no** el contenido de la clave pública.
{% endhint %}
{% endtab %}

{% tab title="Variables de entorno" %}
También puedes definir **variables de entorno personalizadas** según las necesidades específicas de tu aplicación.

Estas variables son **opcionales**, y resultan útiles para configurar bases de datos, servicios externos o cualquier parámetro sensible que no quieras dejar _hardcodeado_.

En particular, **estas variables son utilizadas por el archivo `docker-compose.yml`** para construir dinámicamente los servicios de tu aplicación.

Por ejemplo:

```yaml
POSTGRES_USER: Usuario de PostgreSQL  
POSTGRES_PASSWORD: Contraseña de PostgreSQL  
POSTGRES_DB: Nombre de la base de datos PostgreSQL  

MONGO_USERNAME: Usuario de MongoDB  
MONGO_PASSWORD: Contraseña de MongoDB
```

{% hint style="danger" %}
Las variables de entorno que definas como secretos deben ser referenciadas tanto en el **workflow** `terraform-ansible.yml`, como también en el **playbook** `deploy_cloud.yml`, para que **Ansible pueda inyectarlas automáticamente en tu archivo** `.env`.

Estos pasos se explican con más detalle en la [**sección de configuración**](configuracion-cloud/).
{% endhint %}
{% endtab %}
{% endtabs %}
{% endstep %}

{% step %}
### Copia los templates de Ansible, Terraform y Workflow

Ve al repositorio [deployment-kit](https://github.com/infra-sandbox/deployment-kit) e ingresa a la carpeta `templates`.

Copia la carpeta `ansible` y la correspondiente a tu proveedor cloud:\
`terraform/aws` **o** `terraform/digitalocean`, y colócalas dentro del directorio de despliegue.

Para el workflow, copia el archivo `terraform-ansible.yml` dentro de la carpeta `.github/workflows` de tu repositorio.
{% endstep %}

{% step %}
### Configura los templates

Revisa la sección [Configuración](configuracion-cloud/) para adaptar los archivos a tu proyecto.

{% hint style="info" %}
Si necesitas ejemplos de cómo pueden ser configuradas las plantillas, puedes revisar el directorio [deployments](https://github.com/infra-sandbox/deployment-kit/tree/main/deployments) dentro del repositorio [deployment-kit](https://github.com/infra-sandbox/deployment-kit). Ahí encontrarás aplicaciones reales donde se han aplicado las plantillas. Además, los ejemplos de workflows se encuentran en la carpeta [.github](https://github.com/infra-sandbox/deployment-kit/tree/main/.github/workflows) en la raíz del repositorio.
{% endhint %}
{% endstep %}

{% step %}
### Ejecuta el workflow

En tu repositorio de GitHub, ve a la pestaña **Actions** en la barra superior.

Busca y selecciona el workflow `terraform-ansible.yml` llamado **"**&#x44;espliegue automatizado en la nub&#x65;**"** (o el nombre que le hayas asignado al archivo).

Haz clic en el botón **"Run workflow"**.

{% hint style="danger" %}
Este workflow está diseñado para ser **ejecutado manualmente** desde GitHub y como **configuración inicial** (no para actualizar la aplicación).&#x20;

Si se vuelve a ejecutar, se duplicará la instancia y los recursos. Asegurate de eliminar la instancia anterior antes de volver a ejecutar el workflow.
{% endhint %}
{% endstep %}
{% endstepper %}

{% hint style="success" %}
Si todo ha funcionado correctamente, deberías poder acceder a tu aplicación desde el navegador con la IP pública de tu instancia (http(s)://\[tu-ip-o-dominio]/).
{% endhint %}

{% hint style="warning" %}
Una vez finalizado el despliegue de tu aplicación, **elimina manualmente la regla del puerto SSH (22)** en el Security Group o Firewall **si ya no utilizarás más GitHub Actions**.\
Mantener este puerto abierto innecesariamente representa un riesgo de seguridad.
{% endhint %}
