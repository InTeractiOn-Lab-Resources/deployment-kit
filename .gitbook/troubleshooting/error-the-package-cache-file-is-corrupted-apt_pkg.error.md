# ERROR: The package cache file is corrupted (apt\_pkg.Error)

Al ejecutar el playbook `deploy_cloud.yml` para DigitalOcean, puede salir el siguiente error:

```vbnet
The error was: apt_pkg.Error:
E:Problem renaming the file /var/cache/apt/pkgcache.bin.bUUQ0S to /var/cache/apt/pkgcache.bin - rename (2: No such file or directory)
W: You may want to run apt-get update to correct these problems
E: The package cache file is corrupted
```

Este error indica que el caché de APT está dañado, lo cual impide que `apt` funcione correctamente. Es común en algunas imágenes de DigitalOcean u otros entornos cloud.

## Solución

Agrega el siguiente bloque como **primera tarea** dentro del `main.yml` del rol **Python** en Ansible:

```yaml
# Limpiar y actualizar el caché de APT (fix DigitalOcean cache corruption)
- name: Limpiar y actualizar el caché de APT
  shell: |
    rm -f /var/cache/apt/pkgcache.bin /var/cache/apt/srcpkgcache.bin || true
    apt-get clean
    apt-get update
  become: true
```
