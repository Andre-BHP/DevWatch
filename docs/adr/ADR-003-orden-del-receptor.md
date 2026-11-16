# ADR-003: Orden de comprobaciones del receptor

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
Un resumen puede tener varios problemas a la vez. La V10 fija los códigos HTTP y que el reenvío se comprueba antes del límite por minuto, pero no el orden completo.

## Decisión
1) tipo de contenido (415); 2) tamaño total (413); 3) JSON válido (400); 4) clave (401); 5) datos obligatorios, admitidos y coherentes (422); 6) reenvío o conflicto (200 o 409); 7) límite por minuto (429 con `Retry-After`); 8) una transacción con regla, evento, incidencia, contadores y recorte (201); 9) si la transacción falla, 503.

## Consecuencias
Los rechazos más baratos se hacen primero. Un reenvío nunca se cuenta contra el límite, como pide la V10.
