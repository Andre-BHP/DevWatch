# ADR-011: Panel sin LiveView

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
La V10 descarta LiveView y pide consultas periódicas cada 5 segundos.

## Decisión
Páginas HTML generadas en el servidor y un JavaScript pequeño que pide un JSON cada 5 segundos solo mientras la página está visible (`visibilitychange`). Si una actualización falla, conserva los datos con su hora y muestra «Actualización pendiente».

## Consecuencias
La única actualización es una consulta periódica fácil de probar.
