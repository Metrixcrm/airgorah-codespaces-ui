#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  wget ca-certificates dbus-x11 \
  libgtk-4-1 libglib2.0-0 libadwaita-1-0 \
  xdg-utils policykit-1

ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
  amd64) AIRGORAH_ARCH="x86_64" ;;
  arm64) AIRGORAH_ARCH="aarch64" ;;
  *) echo "Unsupported Debian architecture: $ARCH"; exit 1 ;;
esac

TMP="/tmp/airgorah.deb"
wget -q --show-progress \
  "https://github.com/martin-olivier/airgorah/releases/download/v0.8.1/airgorah_0.8.1_${AIRGORAH_ARCH}.deb" \
  -O "$TMP"

sudo apt-get install -y "$TMP"
rm -f "$TMP"

echo "Airgorah v0.8.1 installed."
echo "The Codespace provides the graphical environment only; a compatible physical Wi-Fi adapter is not supplied by Codespaces."
