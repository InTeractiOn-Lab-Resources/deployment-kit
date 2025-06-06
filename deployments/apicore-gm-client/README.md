# Stack de prueba: API Core + API GM + Client

Esta carpeta contiene archivos que permiten levantar un ecosistema de pruebas compuesto por los siguientes servicios:

- **api-core-test**: Microservicio básico que expone la ruta `/core` y que permite interactuar con la base de datos MongoDB.
- **api-gm-test**: Microservicio básico que expone la ruta `/gm` y que permite interactuar con la base de datos PostgreSQL.
- **client-test**: Aplicación frontend simple que permite enviar peticiones HTTP a ambos microservicios y visualizar las respuestas.
