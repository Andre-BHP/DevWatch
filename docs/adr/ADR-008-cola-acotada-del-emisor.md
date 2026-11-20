# ADR-008: Cola acotada del emisor

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
Hueco de la V10: si la plataforma no está disponible, cada resumen espera hasta 1 + 2 + 4 segundos más los tiempos de espera de 5 segundos, y los resúmenes en memoria podrían crecer sin control.

## Decisión
El emisor limita los envíos en curso (por defecto 200, configurable). Al superarlo, el resumen se descarta con un aviso local que indica que quedó sin confirmación de entrega.

## Consecuencias
El paquete nunca hace crecer sin control la memoria de la aplicación observada. Es coherente con la V10, que ya acepta perder los resúmenes que agotan sus reintentos. Conviene mencionarlo en una siguiente versión de la propuesta.
