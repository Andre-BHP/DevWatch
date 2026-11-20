# ADR-014: Alcance de la autenticación generada

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
`mix phx.gen.auth` de Phoenix 1.8 genera, además de correo y contraseña, inicio de sesión por enlace mágico, confirmación de correo y buzón de desarrollo. La V10 define la cuenta con nombre, correo y contraseña (12 a 128 caracteres), inicio de sesión con correo y contraseña, y no menciona correos.

## Decisión
Se conserva lo generado que coincide con la V10 (huella Argon2id, sesión con token en base de datos y cookie firmada, cierre de sesión que borra el token). Se agrega el nombre obligatorio, el registro pide la contraseña y la longitud es de 12 a 128. Se retiran el enlace mágico, la confirmación por correo y el envío de correos, para no agregar funciones fuera de la V10.

## Consecuencias
El recorrido de la V10 (crear cuenta, iniciar sesión, cerrar sesión) queda completo sin dependencias de correo.
