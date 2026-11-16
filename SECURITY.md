# Seguridad

DevWatch es un proyecto académico. Si encuentras una vulnerabilidad, abre un aviso privado en
GitHub (pestaña Security, "Report a vulnerability") en lugar de un issue público.

Prácticas del proyecto:
- Ningún secreto en el repositorio: `.env` está ignorado y `.env.example` solo lleva marcadores.
- Contraseñas con Argon2id; claves de aplicación y valores de sesión de 32 bytes aleatorios; de las claves solo se guarda su huella SHA-256.
- Cada consulta de una ficha se limita a la cuenta que la hace; una ficha ajena responde como inexistente.
- HTML siempre escapado y política de seguridad de contenido que solo permite recursos propios.
- La API key del asistente vive solo en una variable de entorno del servidor.
- Todos los datos de prueba son ficticios.
