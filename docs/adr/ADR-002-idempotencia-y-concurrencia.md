# ADR-002: Idempotencia y concurrencia en la base de datos

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
La V10 exige que la base impida guardar dos veces la misma identificación por ficha aunque lleguen dos envíos a la vez, que dos apariciones simultáneas no abran dos incidencias y que los contadores se actualicen por turno.

## Decisión
Restricción `UNIQUE (aplicacion_id, aparicion_id)` en eventos e inserción con `ON CONFLICT DO NOTHING`; si no inserta, se compara la huella para responder 200 o 409. Incidencias con `UNIQUE (aplicacion_id, entorno, huella_firma)` e `INSERT ... ON CONFLICT DO UPDATE` que suma la aparición. Contadores (acumulados, recuentos por minuto y recepción por minuto) con upsert y suma atómica.

## Consecuencias
La comprobación de la V10 («volver a comprobar que no exista otra») la hace la propia base, sin condiciones de carrera ni bloqueos explícitos.
