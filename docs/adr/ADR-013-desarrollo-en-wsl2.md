# ADR-013: Desarrollo de la plataforma en WSL2

- Estado: aceptada
- Fecha: 2026-11-15

## Contexto
`argon2_elixir` (Argon2id, exigido por la V10) compila código C con `nmake`. En Windows no están instaladas las herramientas de C++ de Visual Studio, así que no compila (`"nmake" not found in the path`, verificado el 2026-11-15).

## Decisión
La plataforma se compila y se prueba en WSL2 (Ubuntu 26.04) con Erlang/OTP 29.0.5 y Elixir 1.20.3 instalados en espacio de usuario (`scripts/wsl_instalar_elixir.sh`, binarios oficiales de builds.hex.pm y de GitHub verificados con SHA-256). El código sigue en `C:\dev\DevWatch` (`/mnt/c/dev/DevWatch`); `_build` y `deps` van a `~/.cache/devwatch` mediante `MIX_BUILD_ROOT` y `MIX_DEPS_PATH` (`scripts/wsl-env.sh`). PostgreSQL 17 sigue siendo el de Windows, visible desde WSL con la red en modo `mirrored`. El paquete y la demo no tienen código nativo y también compilan en Windows. El CI usa Ubuntu, igual que WSL.

## Consecuencias
Se necesita `build-essential` en WSL (lo instala André). Las versiones de Windows, WSL, CI y `.tool-versions` son las mismas.
