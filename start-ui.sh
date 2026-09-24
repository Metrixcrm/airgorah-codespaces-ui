#!/usr/bin/env bash
set -euo pipefail

export DISPLAY="${DISPLAY:-:1}"
export GDK_BACKEND="${GDK_BACKEND:-x11}"

if ! command -v airgorah >/dev/null 2>&1; then
  echo "Airgorah is not installed yet. Rebuild the Codespace container first."
  exit 1
fi

if pgrep -x airgorah >/dev/null 2>&1; then
  echo "Airgorah is already running."
  exit 0
fi

mkdir -p "$HOME/.config/airgorah"

echo "Starting Airgorah GTK UI on DISPLAY=$DISPLAY ..."
nohup dbus-run-session -- airgorah >"$HOME/airgorah.log" 2>&1 &
PID=$!

echo "Airgorah PID: $PID"
echo "Browser desktop: forward/open port 6080 from the PORTS tab."
echo "Log: $HOME/airgorah.log"
