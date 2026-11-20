# ADR-005: Recorte a 5,000 detalles

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
La V10 conserva el detalle de los 5,000 eventos más recientes por ficha, sumando ambos entornos, sin perder métricas.

## Decisión
Dentro de la misma transacción del evento, después de sumar acumulados y apariciones, se borra el detalle más antiguo de la ficha cuando el conteo pasa de 5,000. Las apariciones de la incidencia conservan hora y aportes.

## Consecuencias
Nunca hay más de 5,000 detalles por ficha y ninguna métrica se pierde.
