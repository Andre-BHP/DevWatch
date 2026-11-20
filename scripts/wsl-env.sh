#!/usr/bin/env bash
# Entorno de desarrollo en WSL2 (ver docs/adr/ADR-013-desarrollo-en-wsl2.md).
# Uso: source scripts/wsl-env.sh   o   scripts/wsl-run.sh <comando>
T="$HOME/.local/share/devwatch-tools"
export PATH="$T/otp-29.0.5/bin:$T/elixir-1.20.3/bin:$HOME/.mix/escripts:$PATH"
export LANG=C.UTF-8 LC_ALL=C.UTF-8
# _build y deps fuera de /mnt/c para que la compilación sea rápida y no se mezcle con Windows.
proyecto="$(basename "$PWD")"
export MIX_BUILD_ROOT="$HOME/.cache/devwatch/$proyecto/_build"
export MIX_DEPS_PATH="$HOME/.cache/devwatch/$proyecto/deps"

# Variables locales (PGUSER, PGPASSWORD, PGHOST...) desde .env, que nunca se sube.
raiz="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$raiz/.env" ]; then
  set -a
  # shellcheck disable=SC1091
  # Quita el BOM y los finales de línea de Windows.
  source <(sed -e '1s/^\xEF\xBB\xBF//' -e 's/\r$//' "$raiz/.env")
  set +a
fi
