#!/usr/bin/env bash
set -u
sleep 3
bash /workspaces/airgorah-codespaces-ui/start-ui.sh >>"$HOME/airgorah-autostart.log" 2>&1 || true
