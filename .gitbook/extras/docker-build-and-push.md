# Docker Build and Push

Este workflow de GitHub Actions permite **construir y publicar automáticamente una imagen Docker en Docker Hub** cada vez que se realizan cambios en la rama principal del repositorio, como parte de un pipeline de automatización.

### Instrucciones

<details>

<summary>Copia el template en tu repositorio</summary>

Copia el archivo `templates/workflows/docker-build-push.yml` en tu repositorio, dentro de `.github/workflows/`.

</details>

<details>

<summary>Configura los siguientes secretos en tu repositorio de GitHub</summary>

* `DOCKER_USERNAME`: Nombre de usuario de Docker Hub.
* `DOCKER_PASSWORD`: Contraseña o token de acceso de Docker Hub.

</details>

<details>

<summary>Ajusta la sección de <code>tags</code> en el workflow para que coincida con el nombre de tu repositorio en Docker Hub</summary>

Cambia `thecariah/app` por el nombre de **tu repositorio** en Docker Hub y elige alguna etiqueta según tus necesidades de versionamiento.

```yaml
# Última versión
tags:
  thecariah/app:latest 
```

```yaml
# Imagen basada en el hash del commit
tags:
  thecariah/app:${{ github.sha }}
```

```yaml
# Versión específica
tags:
  thecariah/app:v1.0.0
```

</details>

<details>

<summary>Asegúrate de que tu <code>Dockerfile</code> esté en el contexto correcto</summary>

Por defecto se apunta al directorio raíz `.` . Si el Dockerfile esta en otra ubicación se debe modificar la sección `context` para que apunte a la ruta correcta:

```yaml
with:
    context: .    # Modificar si es necesario
```

</details>

<details>

<summary>Controla cuándo se ejecuta el workflow</summary>

* Si deseas que el workflow solo se dispare cuando se modifican ciertos archivos (por ejemplo, Dockerfile o archivos `.py`), agrega la sección `paths` .

```yaml
on:
  push:
    branches:
      - main
    paths:
    # Modifica según sea necesario
      - '**/Dockerfile'
      - '**/*.py'
```

* Si deseas que el workflow siempre se ejecute, no incluyas la sección `paths`.

</details>

