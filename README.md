# DevWatch

Plataforma de monitoreo para aplicaciones Elixir en desarrollo y pruebas. Recibe el resumen de cada operación observada, detecta fallos y demoras con un **catálogo de reglas propio y explicable**, agrupa los problemas en **incidencias con severidad calculada** y muestra métricas por entorno.

Proyecto de André Bernard Heredia Pérez (CETI Colomos, Desarrollo de Software). Especificación: propuesta V10 (04/11/2026). Avance en [`PROGRESO.md`](PROGRESO.md).

[![CI](https://github.com/Andre-BHP/DevWatch/actions/workflows/ci.yml/badge.svg)](https://github.com/Andre-BHP/DevWatch/actions/workflows/ci.yml)

## Piezas

| Carpeta | Qué es |
|---|---|
| [`devwatch/`](devwatch) | La plataforma: Phoenix sin LiveView y PostgreSQL. Cuentas, fichas y claves, receptor `POST /api/eventos`, motor de reglas, incidencias, alertas, métricas, panel y asistente |
| `integrations/devwatch_capture/` | El paquete que se instala en la aplicación observada: `medir/3`, `mensaje/3`, adaptadores Postgres y HTTP, emisor con reintentos y supervisor (desde F1) |
| `demo/rentas_demo/` y `demo/servicio_controlado/` | Aplicación de demostración de rentas de vehículos ficticios y servicio controlado (desde F1) |
| [`docs/`](docs) | [Requisitos numerados](docs/requisitos.md), [decisiones de arquitectura](docs/adr/README.md), guía de uso, catálogo de reglas y evidencias de pruebas |

## Requisitos

- Erlang/OTP 29.0.5 y Elixir 1.20.3 (`.tool-versions`).
- PostgreSQL 17.
- Para la plataforma, un compilador de C (`argon2_elixir`). En Windows se desarrolla en WSL2: ver [ADR-013](docs/adr/ADR-013-desarrollo-en-wsl2.md).

## Ejecutar la plataforma

```bash
cd devwatch
mix setup          # dependencias, base de datos y migraciones
mix phx.server     # http://localhost:4000
```

Las credenciales de la base local se leen de `PGUSER`, `PGPASSWORD` y `PGHOST` (ver [`.env.example`](.env.example)).

En Windows con WSL2:

```bash
wsl -d Ubuntu -e bash scripts/wsl-run.sh devwatch mix test
```

## Calidad

Cada push corre en CI: formato, compilación sin advertencias, Credo estricto, Sobelow, auditoría de dependencias, Dialyzer y pruebas con cobertura.

```bash
cd devwatch
mix calidad
mix test
```

## Forma de trabajo

- Fases F0 a F9 en orden; cada una en una rama `fase/fN-...` con PR a `main`, etiqueta `v0.N.0` y entrada en [`CHANGELOG.md`](CHANGELOG.md).
- Conventional Commits.
- Cada caso de prueba de la V10 (`PR-xx`) deja su evidencia en `docs/evidencias/PR-xx/`.

## Licencia

[MIT](LICENSE).
