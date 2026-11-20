# ADR-007: Ubicación en la traza

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
La V10 muestra la primera referencia de la traza que pertenece a la aplicación observada y conserva el orden de todas.

## Decisión
El paquete marca cada referencia como propia si `Application.get_application(modulo)` coincide con el nombre de aplicación configurado. Se envía la lista ordenada con módulo, función, aridad, archivo, línea y la marca; nunca el contenido de archivos.

## Consecuencias
La plataforma no necesita conocer el código de la aplicación para elegir la ubicación.
