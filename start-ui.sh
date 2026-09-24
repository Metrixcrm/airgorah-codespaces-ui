#!/usr/bin/env bash
set -euo pipefail

export DISPLAY="${DISPLAY:-:1}"
export GDK_BACKEND="${GDK_BACKEND:-x11}"

ROOT="/workspaces/airgorah-codespaces-ui"

if ! command -v airgorah >/dev/null 2>&1; then
  echo "Airgorah is not installed. Installing Airgorah v0.8.1 now..."
  if [ ! -f "$ROOT/.devcontainer/setup.sh" ]; then
    echo "ERROR: .devcontainer/setup.sh is missing."
    exit 1
  fi
  sudo bash "$ROOT/.devcontainer/setup.sh"
fi

if ! command -v airgorah >/dev/null 2>&1; then
  echo "ERROR: Airgorah installation did not complete."
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

sleep 2
if kill -0 "$PID" 2>/dev/null; then
  echo "Airgorah started (PID $PID)."
else
  echo "Airgorah failed to start. Last log lines:"
  tail -n 60 "$HOME/airgorah.log" 2>/dev/null || true
  exit 1
fi

echo "Open port 6080 from the Codespace PORTS tab."
if [ -n "${CODESPACE_NAME:-}" ] && [ -n "${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-}" ]; then
  echo "Codespaces UI: https://${CODESPACE_NAME}-6080.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
fi
