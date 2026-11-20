# Encargo inicial de DEVWATCH

Lee `CLAUDE.md` (reglas fijas), la V10 completa y `PLAN_DEVWATCH.md`. Después construye DevWatch fase por fase.

## Qué es
Una plataforma web que recibe resúmenes de operaciones ejecutadas en aplicaciones Elixir, detecta fallos y demoras con un catálogo de reglas propio y explicable, agrupa los problemas en incidencias con severidad calculada y alertas, y muestra métricas. Tiene tres piezas en este repositorio:
- **El paquete** `integrations/devwatch_capture`: `medir/3`, `mensaje/3`, adaptadores Postgres y HTTP, emisor con reintentos y supervisor.
- **La plataforma** `devwatch`: Phoenix sin LiveView con PostgreSQL.
- **La demo** `demo/rentas_demo`, con `demo/servicio_controlado`.

Los nombres de archivos, módulos, códigos HTTP y SQLSTATE y las excepciones están en el punto 10 de la V10: úsalos tal cual.

## Orden de trabajo
| Fase | Qué |
|---|---|
| F0 | Base: repositorio, `.tool-versions`, `phx.new --no-live --no-tailwind`, `phx.gen.auth` con Argon2, CI (format, Credo, Dialyxir, Sobelow, `deps.audit`, pruebas), README, ADR-001 a 012 del plan y `PROGRESO.md` |
| F1 | Esqueleto completo: `medir/3` mínimo, receptor que guarda el evento y lista simple. Una operación de la demo llega a su ficha |
| F2 | Recepción robusta: validación, todos los códigos, reenvío y conflicto, 600 por minuto, tamaños, reintentos 1, 2 y 4, avisos locales y cola acotada |
| F3 | Motor de reglas versionado, con pruebas por regla, bordes y propiedades. `catalogo_de_reglas.md` se genera desde el código |
| F4 | Incidencias, firma, estados e historial, severidad de 5 minutos, alertas y procesos periódicos con reloj inyectable |
| F5 | Métricas, acumulados, recorte a 5,000 y retención de 24 h y 30 días |
| F6 | Panel: fichas, claves, eventos, incidencias, alertas, actualización cada 5 s, `DESIGN.md`, axe y teclado, y seguridad entre cuentas |
| F7 | Demo completa con todas las pruebas funcionales de la V10 |
| F8 | Asistente con Claude Haiku 5.5: filtro de secretos, caché e inyección tratada como dato. Antes de programarlo, verifica el id del modelo y la API en la documentación oficial de Anthropic. Si no hay API key, déjalo detrás de una variable de entorno y pruébalo con Mox |
| F9 | Despliegue documentado (Docker Compose y Caddy), k6 de capacidad, guía final, release `v1.0.0` con zip del paquete y ExDoc en Pages |

## Primer turno
1. **Lee todo:** CLAUDE.md, la V10 y el plan. Haz una lista en `docs/requisitos.md` con cada requisito y cada caso de prueba de la V10 numerados por módulo (RF-xx y PR-xx). Es la base de los issues y del reporte.
2. **F0 completa,** con su push.
3. **Avísale a André** el enlace del repositorio y lo que necesites de él (crear el repositorio, instalar algo, una API key). Después sigue con F1 sin esperar, salvo que estés bloqueado.

## Al terminar todo
Reporte breve: enlace del repositorio y del release, pruebas aprobadas y totales por tipo, resultado de capacidad, ADR que cambian algo de la V10 y qué falta para entregar.
