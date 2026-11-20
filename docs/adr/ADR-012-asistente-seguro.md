# ADR-012: Asistente seguro

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
La V10 pide filtro de secretos, tratar los mensajes de eventos como datos y que el asistente sea opcional.

## Decisión
Filtro de secretos (etiquetas contraseña, clave o credencial, y correos) antes de enviar. Datos de la incidencia dentro de etiquetas `<datos_incidencia>` con la instrucción de tratarlos como datos. Guía y catálogo marcados para la caché de instrucciones. Tiempo de espera y «No se pudo obtener respuesta». La API key solo en `ANTHROPIC_API_KEY` del servidor; sin ella el asistente queda desactivado y el resto funciona. Las pruebas usan Mox.

## Consecuencias
El asistente no puede modificar clasificaciones ni ver la base de datos.
