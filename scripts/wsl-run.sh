#!/usr/bin/env bash
# Ejecuta un comando dentro de una carpeta del repositorio con el entorno de WSL.
# Uso: scripts/wsl-run.sh <carpeta> <comando...>
set -euo pipefail
cd "$1"; shift
source "$(dirname "$0")/wsl-env.sh" 2>/dev/null || source /mnt/c/dev/DevWatch/scripts/wsl-env.sh
exec "$@"
