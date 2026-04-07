# CogOS Charts

> Part of the [CogOS ecosystem](https://github.com/cogos-dev) — **how it DEPLOYS**

Helm charts and deployment manifests for CogOS nodes.

This repo defines what a CogOS node **is** by default — and what it **can be**.

## Charts

| Chart | What it deploys | Status |
|-------|----------------|--------|
| **cogos-node** | Complete node (kernel + selected organelles) | Primary — start here |
| **cogos-kernel** | Kernel only (the daemon) | Standalone component |
| **cogos-mod3** | Mod³ modality server (TTS, VAD, STT) | Standalone component |

### cogos-node (the umbrella chart)

Deploys a complete CogOS node as a single unit. Includes the kernel by default and optionally enables additional organelles:

```sh
# Default: kernel only
helm install my-node charts/cogos-node

# With Mod³ modality server
helm install my-node charts/cogos-node --set mod3.enabled=true

# With custom workspace path
helm install my-node charts/cogos-node --set workspace.path=/data/my-workspace
```

The node chart pins specific versions of each organelle. Upgrading the chart upgrades the whole node — like a Kubernetes release bundling component versions.

### Component charts

Each organelle has its own chart for standalone deployment or custom compositions:

```sh
# Kernel only
helm install kernel charts/cogos-kernel --set workspace.path=/data/workspace

# Mod³ only (connects to existing kernel)
helm install mod3 charts/cogos-mod3 --set kernel.endpoint=http://cogos-kernel:5200
```

## Docker Compose (local development)

For local development without Kubernetes:

```sh
docker compose up        # Start the full node
docker compose up cogos  # Kernel only
```

## Version Pinning

The node chart defines the tested combination of organelle versions:

```yaml
# charts/cogos-node/Chart.yaml
dependencies:
  - name: cogos-kernel
    version: "0.1.x"
  - name: cogos-mod3
    version: "0.2.x"
    condition: mod3.enabled
```

Upgrade the node chart → upgrade all organelles together, tested as a unit.

## Architecture

```
cogos-dev/charts          ← this repo (orchestration layer)
  charts/cogos-node       ← umbrella: "what is a CogOS node?"
  charts/cogos-kernel     ← the daemon
  charts/cogos-mod3       ← modality server
  docker-compose.yml      ← local dev alternative

cogos-dev/cogos           ← kernel source + Dockerfile
cogos-dev/mod3            ← modality source + Dockerfile
cogos-dev/constellation   ← identity/trust source + Dockerfile
```

Each organelle repo builds and publishes its own container image. This repo composes them into deployable units.

## Local macOS Note

On macOS, the kernel can run in a container but Mod³ typically runs on bare metal (Docker containers can't access host audio devices). The compose file handles this:

```yaml
services:
  cogos:
    image: cogos-dev/cogos:latest    # containerized
    ports: ["5200:5200"]

  # mod3 runs on host, connects to kernel via network
  # Start separately: mod3 serve --kernel http://localhost:5200
```

For headless servers or Linux, everything can be fully containerized.

## License

MIT
