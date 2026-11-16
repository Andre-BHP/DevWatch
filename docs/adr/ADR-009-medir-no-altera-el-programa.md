# ADR-009: `medir/3` no altera el programa

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
La V10 exige que la función de captura devuelva la misma respuesta y vuelva a lanzar la misma excepción.

## Decisión
`medir/3` devuelve exactamente el valor de la operación; `rescue` vuelve a lanzar con `reraise` y la traza original; `catch` de `throw` y `exit` los deja seguir con `throw/1` y `exit/1`. El envío ocurre en una tarea separada.

## Consecuencias
La prueba de instalación (PR-18) compara la respuesta con y sin captura.
