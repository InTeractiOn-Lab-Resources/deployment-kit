---
description: >-
  Variables clave, estructura esperada y recomendaciones para adaptar el
  playbook a tu proyecto.
---

# Ansible cloud

Esta sección explica cómo configurar los archivos necesarios de **Ansible** para desplegar tu aplicación en un entorno cloud (AWS o DigitalOcean).

Ansible es una herramienta de **automatización** que permite instalar dependencias, copiar archivos, configurar servicios como Nginx y generar automáticamente el archivo `.env` dentro de la instancia creada por Terraform.

Toda esta configuración se orquesta a través de un **playbook centralizado** que puedes personalizar según las necesidades de tu aplicación.

## Estructura

Asegúrate de tener la siguiente estructura dentro de tu carpeta de despliegue:

```
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

## Playbook a usar

Este entorno cloud usa el playbook:

```
ansible/playbooks/deploy_cloud.yml
```

## Instrucciones

<details>

<summary>Nombre del proyecto</summary>

En la sección **Configuración básica del proyecto**, define el nombre de tu aplicación en `project_name`:

```yaml
project_name: "app"
```

</details>

<details>

<summary>Modo de despliegue</summary>

En la sección **Configuración básica del proyecto**,  define el modo de despliegue de tu aplicación:

#### **Opción 1:**

Usa imágenes Docker ya construidas y publicadas, por ejemplo desde Docker Hub. Este modo **es** **recomendado** ya que es más rápido y se puede usar en conjunto con un workflow de CI.

```yaml
clone_repos: false
```

{% hint style="info" %}
**¿No tienes CI configurado?** Aprende a subir tu aplicación a Docker Hub con el workflow [Docker Build and Push](../../extras/docker-build-and-push.md).
{% endhint %}

#### Opción 2:

Clona los repositorios directamente desde GitHub y construye las imágenes Docker en el servidor. Este modo es útil para cuando quieres hacer despliegues directamente desde el código.

```yaml
clone_repos: true
```

</details>

<details>

<summary>Uso de archivo <code>.env</code> en Docker Compose</summary>

Si utilizas un archivo `.env` para la ejecución del **docker compose**, entonces en la sección **Configuración básica del proyecto** debe estar lo siguiente:

```yaml
use_env_file: true
```

{% hint style="danger" %}
Recuerda que si utilizas `.env` para tu **docker compose**, debes definir las variables en `global_env_vars` como se indica en la instrucción **Variables de entorno.**

Si las variables son **propias de un servicio** deben estar definidas en `env_var` donde corresponda. Esto se indica en la instrucción **Añadir servicios.**
{% endhint %}

De lo contrario, debes asignar la variable así:

```
use_env_file: false
```

{% hint style="info" %}
Si no utilizas un archivo `.env` para tu `docker-compose`, el playbook generará automáticamente un `.env` vacío. Esto no afecta el funcionamiento de tu aplicación y previene posibles errores.
{% endhint %}

</details>

<details>

<summary>Archivos para copiar</summary>

De forma predeterminada, el playbook copia el archivo `docker-compose.yml` ubicado en el directorio principal de despliegue.

Además, puedes definir **archivos adicionales** que tu aplicación necesite para funcionar correctamente (por ejemplo, scripts de inicialización como `init.sql`,  etc).

Para esto, dirígete a la sección **Configuración básica del proyecto** y utiliza el parámetro `additional_files` para listar todos los archivos que deseas copiar dentro de la instancia:

```yaml
additional_files:
    - "init.sql"
```

{% hint style="warning" %}
**Este paso es opcional**. Si no necesitas copiar archivos adicionales, puedes dejar `additional_files` sin definir.
{% endhint %}

</details>

<details>

<summary><strong>Añadir servicios</strong></summary>

Dirígete a la sección **Configuración de servicios** del playbook.

Para añadir un nuevo servicio, edita la lista `services` agregando un bloque como el siguiente:

```yaml
services:
  - name: "nuevo_servicio"
    type: "api"
    image: "usuario/nuevo-servicio"
    tag: "latest"
    port: 3001
    env_var: "NUEVO_SERVICIO_IMAGE"
    api_prefix: "nuevo-servicio"
```

{% hint style="danger" %}
Si estás utilizando `clone_repos: true`, **no debes incluir los parámetros** `image` **,** `tag` ni `env_var`, ya que el despliegue se realizará clonando directamente los repositorios y no utilizando Docker Hub.

En el caso de `env_var`, esta variable debe ir establecida en `service_repos` (y no en `services`) como se muestra más abajo.
{% endhint %}

Para añadir el frontend en `services`, debes añadir `frontend_prefix` y cambiar el campo `type`:

```yaml
- name: "client"
  type: "frontend"
  port: 3000
  frontend_prefix: "/"
```

{% hint style="info" %}
El campo `frontend_prefix` se utiliza para **definir la ruta base en Nginx donde se expondrá este frontend**. Por ejemplo, si `frontend_prefix` está definido como `/`, el frontend será accesible directamente en la raíz del dominio (`https://midominio.com/`).

Si tienes múltiples frontends, puedes asignarles distintos valores en `frontend_prefix` para diferenciarlos dentro de la configuración de rutas de Nginx.

También es válido no definir `frontend_prefix`; en ese caso, el servicio será accesible directamente a través de su puerto asignado, sin pasar por el proxy de Nginx.
{% endhint %}

Si seleccionaste como modo de despliegue la opción para **clonar repositorios** (`clone_repos: true`), también debes añadir la siguiente sección `service_repos`. De lo contrario, puedes **omitir este paso**.

```yaml
service_repos:
  - name: "nuevo-servicio"
    url: "https://github.com/mi-organizacion/app.git"
    branch: "main"
    env_var: "NUEVO_SERVICIO_PATH"
    service: "nuevo_servicio"
```

{% hint style="danger" %}
El campo `service` en `service_repos` debe coincidir exactamente con el campo `name` en la sección `services`. Este es el enlace que permite a Ansible saber qué repositorio corresponde a qué servicio.
{% endhint %}

</details>

<details>

<summary>Variables de entorno</summary>

Dirígete a la sección **Configuración de servicios**.

En el parámetro `global_env_vars` puedes definir todas las variables de entorno necesarias para generar automáticamente el archivo `.env` dentro de la instancia.

Puedes incluir tanto variables hardcodeadas como variables inyectadas desde los **secretos definidos en el workflow**, las cuales se referencian en el playbook de Ansible.

Siguiendo el ejemplo de configuración del workflow, esta sección podría quedar así:

```yaml
global_env_vars:
  # Variables inyectadas desde los secretos del workflow
  POSTGRES_DB: "{{ postgres_db }}"
  POSTGRES_USER: "{{ postgres_user }}"
  POSTGRES_PASSWORD: "{{ postgres_password }}"
  MONGO_USERNAME: "{{ mongo_username }}"
  MONGO_PASSWORD: "{{ mongo_password }}"
  # Variable harcodeada
  INIT_SQL_PATH: "{{ project_root }}/init.sql"
```

{% hint style="info" %}
Si no necesitas definir variables de entorno, puedes dejar este parámetro vacío o simplemente eliminarlo.
{% endhint %}

{% hint style="danger" %}
Si estás inyectando secretos desde el workflow, debes usar exactamente los mismos nombres que definiste en el archivo `vars.yml` del job correspondiente `provision-instance`.
{% endhint %}

</details>

<details>

<summary>Nginx y rutas</summary>

El parámetro`use_trailing_slash` define si Nginx debe agregar una barra `/` al final de las rutas configuradas con `proxy_pass`.

#### **Opción 1:**

```yaml
use_trailing_slash: true
```

Cuando el valor es `true`, Nginx agregará una barra al final del `proxy_pass`. Esto genera rutas como:&#x20;

```nginx
proxy_pass http://localhost:3000/; 
```

{% hint style="info" %}
Por defecto este parámetro es `true`, incluso cuando no sea definido.
{% endhint %}

#### **Opción 2:**

```yaml
use_trailing_slash: false
```

Cuando el valor es `false`, Nginx no agregará una barra al final:&#x20;

```nginx
proxy_pass http://localhost:3000;
```

Esto puede ser necesario si estás trabajando con APIs que manejan rutas de forma estricta (por ejemplo, `/api/users` es diferente a `/api/users/`), o si tu backend espera rutas sin barra final.

{% hint style="danger" %}
### Importante

Si detectas problemas con rutas internas, redirecciones inesperadas o errores en la comunicación de servicios, prueba cambiar este valor y vuelve a probar tu aplicación.
{% endhint %}

</details>

<details>

<summary><strong>Nginx y certificación</strong></summary>

Dirígete a la sección **Configuración de Nginx**.

Si tienes un **dominio disponible**, debes asignarlo en la variable `server_name`. En caso contrario, puedes usar la **IP pública** por defecto dejando:

```yaml
server_name: "_"
```

Al utilizar un dominio, se debe **activar el uso de SSL** para obtener los certificados necesarios para el protocolo HTTPS. Debes activar la variable `enable_ssl` e ingresar tu email en `admin_email`.

```yaml
enable_ssl: true
admin_email: "tu_email@usach.cl"
ssl_cert_path: "/etc/letsencrypt/live/{{ server_name }}/fullchain.pem"
ssl_key_path: "/etc/letsencrypt/live/{{ server_name }}/privkey.pem"
```

Si vas a utilizar solo una IP pública, se debe **desactivar el uso de SSL** mediante la variable `enable_ssl` y eliminar los campos relacionados con certificados (`ssl_cert_path`, `ssl_key_path`, `admin_email`)

```yaml
enable_ssl: false
```

{% hint style="info" %}
Esta plantilla está preparada para usar **Certbot (Let's Encrypt)** por defecto, mediante el rol `ssl`. Sin embargo, si prefieres usar otra tecnología (por ejemplo: certificados manuales, ZeroSSL u otro método), puedes adaptar fácilmente el rol o hacer que las rutas `ssl_cert_path` y `ssl_key_path` apunten a archivos reales.
{% endhint %}

</details>

{% hint style="success" %}
La configuración está completa. Ahora, asegúrate de volver a las [instrucciones](../instrucciones-cloud.md) para revisar cómo ejecutar correctamente el workflow y finalizar el despliegue.
{% endhint %}
