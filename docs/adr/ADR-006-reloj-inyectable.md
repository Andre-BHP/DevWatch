# ADR-006: Reloj inyectable

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
La V10 pide un reloj que controla la prueba para comprobar la ventana de 5 minutos, las 24 horas y los 30 días.

## Decisión
`DevWatch.Clock` es un behaviour con `now/0` (UTC). La implementación real usa `DateTime.utc_now/0`; en pruebas se usa un reloj controlado por la prueba. Los procesos periódicos y los cálculos reciben la hora del reloj.

## Consecuencias
Las pruebas de bordes de tiempo son deterministas.
