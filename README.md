# Airgorah Codespaces UI

Browser-accessible Linux desktop environment for the official **Airgorah v0.8.1** GTK application.

Airgorah is a Linux Wi-Fi security auditing application. This repository does not emulate or provide wireless hardware; GitHub Codespaces normally has no physical Wi-Fi adapter exposed to the container.

## Quick start

1. Open this repository in GitHub Codespaces.
2. Let the dev container finish creating. The setup script installs the official Airgorah v0.8.1 Debian package.
3. In the Codespaces terminal run:

```bash
bash start-ui.sh
```

4. Open the forwarded **6080** port from the **PORTS** tab.
5. The browser desktop displays the GTK application.

## Verify installation

```bash
airgorah --version
```

You can also inspect the application log:

```bash
cat ~/airgorah.log
```

## Hardware limitation

The official Airgorah documentation requires a Linux wireless adapter capable of monitor mode and packet injection for wireless auditing. A normal GitHub Codespace does not provide such a radio device. Therefore this repository is intended for testing the application/UI environment, not as a substitute for a Linux machine with compatible Wi-Fi hardware.

Use Airgorah only on networks and equipment you own or are explicitly authorized to test.

## Official project

https://github.com/martin-olivier/airgorah

Official installation documentation:

https://github.com/martin-olivier/airgorah/wiki/Installation
