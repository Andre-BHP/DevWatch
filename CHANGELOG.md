# Cambios

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y versiones [SemVer](https://semver.org/lang/es/). Una versión `v0.N.0` por fase.

## [0.0.0] - F0 Base - 2026-11-15
### Agregado
- Requisitos de la V10 numerados por módulo (`docs/requisitos.md`): 107 RF, 16 RNF y 49 casos de prueba.
- ADR-001 a ADR-014.
- Plataforma Phoenix 1.8 sin LiveView ni Tailwind, con PostgreSQL.
- Cuentas con nombre, correo y contraseña (12 a 128 caracteres, Argon2id), inicio y cierre de sesión con sesión en base de datos y cookie firmada.
- `DESIGN.md` con tokens y hoja de estilos propia.
- CI: formato, compilación sin advertencias, Credo, Sobelow, auditoría de dependencias, Dialyzer y pruebas con cobertura.
- Entorno de desarrollo en WSL2 (`scripts/`).
