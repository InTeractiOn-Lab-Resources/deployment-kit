# ERROR: Unprotected private key file, permissions are too open

Al extraer la clave pública `.pub` desde una clave privada `.pem`, puede ocurrir un error de permisos que deniega esta acción.

Para resolver esto se debe hacer lo siguiente:

```bash
chmod 400 tu-archivo.pem
```
