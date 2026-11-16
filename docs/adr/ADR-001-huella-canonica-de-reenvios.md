# ADR-001: Huella del contenido para reenvíos

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
La V10 (punto 7, recepción) distingue un reenvío (misma identificación y mismo contenido, 200) de un conflicto (misma identificación y otro contenido, 409). No define cómo se compara el contenido. El mismo resumen serializado con las claves en otro orden o con otros espacios daría un 409 falso.

## Decisión
Antes de calcular el SHA-256, el resumen ya decodificado se serializa en JSON canónico: claves de objetos ordenadas de forma recursiva, sin espacios, UTF-8. La huella se guarda en `identificaciones_recientes` durante 24 horas.

## Consecuencias
Dos envíos semánticamente iguales siempre dan la misma huella. El paquete no necesita serializar de forma determinista.
