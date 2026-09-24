#!/usr/bin/env bash
set -u

LOG="$HOME/airgorah-autostart.log"
exec >>"$LOG" 2>&1

echo "=== Codespace desktop startup $(date) ==="

# desktop-lite installs its startup entrypoint here. Codespaces does not always
# invoke feature entrypoints in the same order as a local dev-container host,
# so explicitly initialize it as a recovery-safe step.
if [ -x /usr/local/share/desktop-init.sh ]; then
  if ! pgrep -x Xtigervnc >/dev/null 2>&1 || ! pgrep -f 'noVNC.*/utils/launch.sh' >/dev/null 2>&1; then
    echo "Initializing desktop-lite..."
    sudo /usr/local/share/desktop-init.sh >/tmp/airgorah-desktop-init.log 2>&1 &
  fi
fi

# Wait for noVNC and the X display.
for i in {1..60}; do
  VNC_OK=0
  NOVNC_OK=0
  X_OK=0

  pgrep -x Xtigervnc >/dev/null 2>&1 && VNC_OK=1
  pgrep -f 'noVNC.*/utils/launch.sh' >/dev/null 2>&1 && NOVNC_OK=1
  DISPLAY=:1 xdpyinfo >/dev/null 2>&1 && X_OK=1

  if [ "$VNC_OK" -eq 1 ] && [ "$NOVNC_OK" -eq 1 ] && [ "$X_OK" -eq 1 ]; then
    break
  fi
  sleep 1
done

echo "Xtigervnc: $VNC_OK | noVNC: $NOVNC_OK | X11: $X_OK"

if [ "$NOVNC_OK" -ne 1 ]; then
  echo "noVNC did not start."
  cat /tmp/airgorah-desktop-init.log 2>/dev/null || true
  exit 1
fi

bash /workspaces/airgorah-codespaces-ui/start-ui.sh
