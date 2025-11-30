---
description: >-
  Variables clave, estructura esperada y recomendaciones para adaptar el
  playbook a tu proyecto.
---

# Ansible local

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
```

## Playbook a usar

Este entorno local usa el playbook:

```
ansible/playbooks/deploy_diinf.yml
```

{% hint style="info" %}
**Nota**: Aunque el nombre indique “diinf”, este playbook funciona tanto en entornos locales como en las VMs del DIINF. La diferencia principal está en los valores asignados a las variables (como `server_name` o `enable_ssl`).
{% endhint %}

## Configurar playbook

<details>

<summary>Modo de despliegue</summary>

**Opción 1:**

Usa imágenes Docker ya construidas y publicadas, por ejemplo desde Docker Hub. Este modo **es** **recomendado** ya que es más rápido y se puede usar en conjunto con un workflow de CI.

```yaml
clone_repos: false
```

{% hint style="info" %}
**¿No tienes CI configurado?** Aprende a subir tu aplicación a Docker Hub con el workflow [Docker Build and Push](../../extras/docker-build-and-push.md).
{% endhint %}

**Opción 2:**

Clona los repositorios directamente desde GitHub y construye las imágenes Docker en la máquina virtual. Este modo es útil para cuando quieres hacer despliegues directamente desde el código.

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
Recuerda que debes crear el archivo `.env` previamente y de forma manual antes de la ejecución del playbook.
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
    api_prefix: "nuevo-servicio"
```

{% hint style="danger" %}
Si estás utilizando `clone_repos: true`, **no debes incluir los parámetros** `image` **ni** `tag`, ya que el despliegue se realizará clonando directamente los repositorios y **no** utilizando imágenes desde Docker Hub.
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
    service: "nuevo_servicio"
```

{% hint style="danger" %}
El campo `service` en `service_repos` debe coincidir exactamente con el campo `name` en la sección `services`. Este es el enlace que permite a Ansible saber qué repositorio corresponde a qué servicio.
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

<summary>Nginx y certificación</summary>

Dirígete a la sección **Configuración de Nginx**.

Para el despliegue local, usualmente **no se utiliza un dominio** ya que se asume que estás desplegando la aplicación directamente en tu máquina.

Por lo tanto, se debe **omitir un nombre de dominio** y **desactivar el uso de SSL**:

```yaml
# Nombre del servidor
server_name: "_"

# Para SSL
enable_ssl: false
```

{% hint style="info" %}
El resto de las variables relacionadas a la certificación (`admin_email`, `ssl_cert_path`, `ssl_key_path`, etc.) pueden quedar comentadas o activadas sin problema. Mientras `enable_ssl` esté en `false`, **el rol de certificación no se ejecutará**, por lo que no afectarán el despliegue.
{% endhint %}

</details>

{% hint style="success" %}
La configuración está completa. Ahora, asegúrate de volver a las [instrucciones](../instrucciones-local.md) para revisar cómo ejecutar correctamente el playbook y finalizar el despliegue.
{% endhint %}
