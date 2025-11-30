# ERROR: Key is stored in legacy trusted.gpg keyring

Al actualizar APT puede salir el siguiente error:

```bash
https://download.docker.com/linux/ubuntu/dists/jammy/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.
```

El sistema detecta que la clave pública usada para verificar los paquetes de Docker está almacenada en el archivo obsoleto `/etc/apt/trusted.gpg`, lo cual genera advertencias al actualizar APT.

## Solución

Identifica la clave de Docker (obsoleta):

```bash
sudo apt-key list
```

Busca una entrada similar a:

```scss
pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
```

Elimina la clave antigua:

```bash
sudo apt-key del 9DC858229FC7DD38854AE2D88D81803C0EBFCD88
```

Agrega nuevamente la clave, pero en el formato correcto (`.gpg`) y en la ubicación recomendada:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg
```

Verifica que la clave fue creada correctamente:

```bash
ls -l /etc/apt/trusted.gpg.d/docker.gpg
```

Actualiza APT y deberías ver una salida limpia, sin advertencias.
