# Progreso de DevWatch

Última subida: **2026-11-16** (hora del centro de México). Especificación: propuesta V10.

## Fases

- [ ] **F0 Base:** repositorio, entorno, Phoenix sin LiveView, cuentas con Argon2id, CI, README, ADR y requisitos *(en revisión: PR abierto)*
- [ ] F1 Esqueleto completo: `medir/3` mínimo, receptor que guarda el evento y lista simple
- [ ] F2 Recepción robusta
- [ ] F3 Motor de reglas
- [ ] F4 Incidencias, severidad y alertas
- [ ] F5 Métricas y retención
- [ ] F6 Panel
- [ ] F7 Demo completa
- [ ] F8 Asistente
- [ ] F9 Despliegue, capacidad y release v1.0.0

## Qué se hizo

- `docs/requisitos.md`: la V10 numerada con 107 RF, 16 RNF y 49 casos de prueba (PR-01 a PR-49).
- ADR-001 a ADR-014 en `docs/adr/`. Dos nuevos respecto al plan:
  - ADR-013: la plataforma se compila en WSL2 porque `argon2_elixir` no compila en Windows sin MSVC.
  - ADR-014: se retiran del generador el enlace mágico, la confirmación por correo y los ajustes de cuenta (no están en la V10).
- Plataforma Phoenix 1.8 sin LiveView ni Tailwind; cuentas con nombre, correo y contraseña de 12 a 128 caracteres; sesión en base de datos con cookie firmada.
- `DESIGN.md` con tokens y CSS propio.
- CI con formato, Credo, Sobelow, auditoría de dependencias, Dialyzer y pruebas con cobertura.

## Pruebas

| Pieza | Aprobadas | Totales |
|---|---|---|
| Plataforma | pendiente de CI | 14 |
| Paquete de captura (F1, en preparación) | 10 | 10 |

## Qué sigue

Cerrar F0 con el CI en verde y seguir con F1: fichas y claves, receptor `POST /api/eventos`, lista de eventos y la primera operación de la demo llegando a su ficha.

## Bloqueos

- La contraseña del rol `devwatch` en el PostgreSQL local no coincide; las pruebas locales esperan esa corrección (el CI usa su propia base).
