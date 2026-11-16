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
