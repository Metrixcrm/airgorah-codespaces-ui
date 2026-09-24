#!/usr/bin/env bash
set -euo pipefail

export DISPLAY="${DISPLAY:-:1}"
export GDK_BACKEND="${GDK_BACKEND:-x11}"

if ! command -v airgorah >/dev/null 2>&1; then
  echo "Airgorah is not installed yet. Rebuild the Codespace container first."
  exit 1
fi

# Give desktop-lite/TigerVNC a moment after the container starts.
for _ in {1..30}; do
  if xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

if ! xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
  echo "Desktop display $DISPLAY is not ready."
  echo "Reopen/restart the Codespace and run: bash start-ui.sh"
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
  echo "Airgorah PID: $PID"
else
  echo "Airgorah failed to start. Last log lines:"
  tail -n 40 "$HOME/airgorah.log" || true
  exit 1
fi

echo "Browser desktop: open port 6080 from the Codespace PORTS tab."
echo "Log: $HOME/airgorah.log"
