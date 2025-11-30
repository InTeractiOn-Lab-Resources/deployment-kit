# ERROR: Failed to update apt cache: clave GPG expirada (MongoDB)

Al ejecutar el playbook, puede salir el siguiente error:

```bash
FAILED! => {"changed": false, "msg": "Failed to update apt cache: W:Updating from such a repository can't be done securely, and is therefore disabled by default., 
W:See apt-secure(8) manpage for repository creation and user configuration details., 
W:GPG error: https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 InRelease: 
The following signatures were invalid: EXPKEYSIG 656408E390CFB1F5 MongoDB 4.4 Release Signing Key <packaging@mongodb.com>, 
E:The repository 'https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 InRelease' is no longer signed."}
```

El error ocurre porque la clave GPG utilizada para verificar el repositorio de MongoDB 4.4 ha **expirado**.\
APT bloquea las actualizaciones desde este repositorio por razones de seguridad, lo que impide que Ansible o el usuario instalen/actualicen paquetes correctamente.

## Solución:

Importa la nueva clave GPG:

```bash
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
```

Actualiza el sistema:

```bash
sudo apt-get update
```
