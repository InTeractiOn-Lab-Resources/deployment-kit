# ERROR: Failed to update apt cache: unknown reason

Al ejecutar el playbook `deploy_diinf.yml` puede salir el siguiente mensaje de error:

```bash
fatal: [localhost]: FAILED! => {"changed": false, "msg": "Failed to update apt cache: unknown reason"}
```

Esto significa que no es posible ejecutar **`update_cache: yes`**, el cual está definido en alguno de los roles de Ansible que requieren actualizar el sistema de paquetes (`apt`).

Al intentar ejecutar manualmente `apt update`, se evidencian errores como:

```bash
Could not connect to 158.170.35.164:8000 - connect (111: Connection refused)
W: Some index files failed to download. They have been ignored, or old ones used instead.
```

El error ocurre porque la máquina tiene configurado un **proxy HTTP no disponible** en el archivo `/etc/apt/apt.conf.d/90curtin-aptproxy`. Este proxy bloquea el acceso a los repositorios de Ubuntu, lo que impide que `apt update` funcione correctamente y genera el fallo del playbook.

## Solución

Verifica la configuración del proxy:

```bash
grep -R "Proxy" /etc/apt/apt.conf.d/
```

Si aparece una línea como esta:

```bash
/etc/apt/apt.conf.d/90curtin-aptproxy:Acquire::http::Proxy "http://158.170.35.164:8000/";
```

Edita el archivo para deshabilitar el proxy:

```bash
sudo nano /etc/apt/apt.conf.d/90curtin-aptproxy
```

Comenta la línea del proxy agregando `//` al inicio:

```bash
// Acquire::http::Proxy "http://158.170.35.164:8000/";
```

Guarda y cierra el archivo (`Ctrl + O`, luego `Enter`, y `Ctrl + X`).&#x20;

Finalmente actualiza APT y deberias ver una salida exitosa.

{% hint style="info" %}
En conjunto con este error, puede salir el error: [Key is stored in legacy trusted.gpg](error-key-is-stored-in-legacy-trusted.gpg-keyring.md)
{% endhint %}
