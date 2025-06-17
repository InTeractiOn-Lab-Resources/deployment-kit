# Stack de prueba: API Core + API GM + Client

Este directorio contiene scripts basados en las plantillas desarrolladas con configuraciones adaptadas para levantar un ecosistema de pruebas compuesto por los siguientes servicios:

- **api-core-test**: Microservicio básico que expone la ruta `/core` y que permite interactuar con la base de datos MongoDB.
- **api-gm-test**: Microservicio básico que expone la ruta `/gm` y que permite interactuar con la base de datos PostgreSQL.
- **client-test**: Aplicación frontend simple que permite enviar peticiones HTTP a ambos microservicios y visualizar las respuestas.

El directorio incluye dos archivos docker-compose:
- docker-compose-build.yml: Utilizado para construir las imágenes localmente y levantar los servicios.
- docker-compose.yml: Utilizado para levantar los servicios a partir de imágenes previamente construidas y publicadas en Docker Hub.
