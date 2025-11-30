# Información entorno DIINF

## Políticas de Seguridad y Red

La red está bajo la política de seguridad que maneja la Dirección Estratégica Informática de la USACH. Por defecto:

* **Acceso externo**: Restringido únicamente a los puertos 80 (HTTP) y 443 (HTTPS)
* **Acceso interno**: Disponible el puerto 22 (SSH)
* **Subred**: El acceso está limitado, solo es posible desde dentro de la universidad o mediante VPN

## Características de las Máquinas Virtuales

### Especificaciones Base

* **Sistema Operativo**: Ubuntu 24.04 (última versión estable)
* **Estado inicial**: Las máquinas se entregan limpias para desarrollo

### Limitaciones de Red

* Solo se puede comunicar con servicios externos a través de los puertos 80 y 443
* La comunicación no es bidireccional
* **Solución alternativa**: Se pueden implementar balanceadores de carga para resolver limitaciones de conectividad
