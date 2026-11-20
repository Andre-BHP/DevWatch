# ADR-004: Límite del cuerpo de la solicitud

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
La V10 limita el resumen a 16,384 bytes, la descripción a 2,000 caracteres y la traza a 8,000.

## Decisión
El pipeline `/api` lee el cuerpo con un límite de 16,384 bytes (413 si se excede) antes de decodificar el JSON. Después, el validador cuenta caracteres (`String.length/1`) de la descripción y la traza (422 indicando el texto).

## Consecuencias
Un texto con acentos dentro del límite de caracteres pero que supera los bytes recibe 413, como pide PR-13.
