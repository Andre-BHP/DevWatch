#!/usr/bin/env bash
# Instala Erlang/OTP y Elixir en espacio de usuario dentro de WSL (sin sudo).
set -euo pipefail
OTP=29.0.5
ELIXIR=1.20.3
OTP_SHA=1ecf8a20104afa053e6701e36ec1485cbce1a2fa4aef962d5e73f9eb5c6e9fc0
T="$HOME/.local/share/devwatch-tools"
mkdir -p "$T/dl"
cd "$T/dl"
[ -f "OTP-$OTP.tar.gz" ] || curl -sfLO "https://builds.hex.pm/builds/otp/ubuntu-24.04/OTP-$OTP.tar.gz"
echo "$OTP_SHA  OTP-$OTP.tar.gz" | sha256sum -c
if [ ! -x "$T/otp-$OTP/bin/erl" ]; then
  mkdir -p "$T/otp-$OTP"
  tar -xzf "OTP-$OTP.tar.gz" -C "$T/otp-$OTP" --strip-components=1
  (cd "$T/otp-$OTP" && ./Install -minimal "$T/otp-$OTP" >/dev/null)
fi
[ -f elixir-otp-29.zip ] || curl -sfLO "https://github.com/elixir-lang/elixir/releases/download/v$ELIXIR/elixir-otp-29.zip"
EXPECTED=$(curl -sfL "https://github.com/elixir-lang/elixir/releases/download/v$ELIXIR/elixir-otp-29.zip.sha256sum" | awk '{print $1}')
echo "$EXPECTED  elixir-otp-29.zip" | sha256sum -c
if [ ! -x "$T/elixir-$ELIXIR/bin/elixir" ]; then
  mkdir -p "$T/elixir-$ELIXIR"
  python3 -c "import zipfile,sys; zipfile.ZipFile(sys.argv[1]).extractall(sys.argv[2])" elixir-otp-29.zip "$T/elixir-$ELIXIR"
  chmod +x "$T/elixir-$ELIXIR"/bin/*
fi
export PATH="$T/otp-$OTP/bin:$T/elixir-$ELIXIR/bin:$PATH"
elixir --version | tail -1
