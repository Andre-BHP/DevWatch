# ADR-010: Catálogo de reglas como datos

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
La V10 pide un catálogo versionado y un `catalogo_de_reglas.md` que se envía al asistente.

## Decisión
El catálogo es una lista ordenada de structs `%Regla{id, evidencia, condicion, categoria, explicacion}` con un atributo de versión en `DevWatch.Rules`. `catalogo_de_reglas.md` se genera desde el código con una tarea mix y el CI comprueba que esté al día.

## Consecuencias
El documento y el código nunca se desincronizan.
