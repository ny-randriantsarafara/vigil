# Getting Started

This guide walks you through running the observability stack locally.

## Prerequisites

- Docker Engine 20.10 or later
- Docker Compose v2 (included with Docker Desktop)
- An application exposing `GET /metrics` (for Prometheus scraping)

Verify your Docker installation:

```bash
docker --version
docker compose version
```

## Setup

### 1. Clone and configure

```bash
git clone <repository-url>
cd observability-stack
cp .env.example .env
```

### 2. Edit environment variables (optional)

Open `.env` and customize values if needed:

| Variable | Default | Description |
|----------|---------|-------------|
| `PROMETHEUS_SCRAPE_TARGET` | `host.docker.internal:3001` | Host and port where your app's `/metrics` endpoint is exposed |
| `PROMETHEUS_JOB_NAME` | `application-api` | Label for the Prometheus job |
| `GRAFANA_PORT` | `3003` | Local port for Grafana UI |
| `PROMETHEUS_PORT` | `9090` | Local port for Prometheus UI |
| `LOKI_PORT` | `3100` | Local port for Loki API |
| `JAEGER_UI_PORT` | `16686` | Local port for Jaeger UI |
| `JAEGER_OTLP_HTTP_PORT` | `4318` | OTLP HTTP port for trace ingestion |
| `PROMETHEUS_RETENTION` | `15d` | How long Prometheus keeps metrics |
| `LOKI_RETENTION` | `168h` | How long Loki keeps logs |
| `GRAFANA_ADMIN_USER` | `admin` | Grafana admin username |
| `GRAFANA_ADMIN_PASSWORD` | `admin` | Grafana admin password |

### 3. Start the stack

```bash
make up
```

Or directly with Docker Compose:

```bash
docker compose up -d
```

### 4. Verify the stack is running

```bash
make ps
```

You should see all four services running: `prometheus`, `grafana`, `loki`, `jaeger`.

Run the smoke tests to confirm health endpoints respond:

```bash
make smoke
```

## Access the UIs

Once the stack is running, open:

| Service | URL | Credentials |
|---------|-----|-------------|
| Grafana | http://localhost:3003 | `admin` / `admin` (or your `.env` values) |
| Prometheus | http://localhost:9090 | None |
| Jaeger | http://localhost:16686 | None |
| Loki | http://localhost:3100/ready | None (API only) |

## Makefile commands

| Command | Description |
|---------|-------------|
| `make up` | Start the stack in detached mode |
| `make down` | Stop the stack |
| `make restart` | Stop and start the stack |
| `make logs` | Tail logs from all services |
| `make ps` | Show running services |
| `make clean` | Stop stack and remove all volumes (data loss) |
| `make validate` | Validate configuration files |
| `make smoke` | Run health check against running services |
| `make help` | Show all available commands |

## Connect your application

### Metrics (Prometheus)

Your application must expose a `GET /metrics` endpoint returning Prometheus-format metrics. Set `PROMETHEUS_SCRAPE_TARGET` to point to your app (e.g., `host.docker.internal:3001` for an app running on host port 3001).

### Logs (Loki)

Push logs to Loki at `http://localhost:3100/loki/api/v1/push`. Use a logging library or agent that supports Loki (e.g., Pino with pino-loki, Winston with winston-loki, or Promtail).

Example environment variable for your app:

```bash
LOKI_URL=http://localhost:3100
```

### Traces (Jaeger via OTLP)

Export traces using OpenTelemetry OTLP HTTP to `http://localhost:4318`.

Example environment variable for your app:

```bash
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318
```

## Deploying to a VPS

The stack can be deployed to any VPS using the `deploy-manual` GitHub Actions workflow. Each VPS is configured as a **GitHub Environment** with its own secrets.

### Adding a new VPS

1. Go to your repo **Settings → Environments → New environment**
2. Name it (e.g. `vps-production`, `vps-staging`)
3. Add these secrets to the environment:

| Secret | Description |
|--------|-------------|
| `SSH_HOST` | VPS IP address or hostname |
| `SSH_USER` | SSH username (e.g. `deploy`) |
| `SSH_PRIVATE_KEY` | Private key for SSH authentication |
| `SSH_PORT` | SSH port (optional, defaults to 22) |

### Triggering a deployment

1. Go to **Actions → deploy-manual → Run workflow**
2. Select the target environment from the dropdown
3. Choose which services to deploy (or `all`)
4. Optionally change the remote path (defaults to `/home/deploy/apps`)

The workflow will copy files to the VPS, pull images, start services, and run smoke tests.

## Stopping the stack

```bash
make down
```

To stop and remove all stored data (metrics, logs, traces):

```bash
make clean
```

## Troubleshooting

### Prometheus cannot scrape my application

- Verify your app is running and `/metrics` returns data: `curl http://localhost:3001/metrics`
- Check `PROMETHEUS_SCRAPE_TARGET` in `.env` matches your app's address
- On Linux, `host.docker.internal` may not resolve; use your machine's IP or enable `extra_hosts` in `docker-compose.yml`

### Grafana shows "No data"

- Confirm the target service (Prometheus, Loki, or Jaeger) is running: `make ps`
- Check the datasource configuration in Grafana at Settings > Data sources
- Review Prometheus targets at http://localhost:9090/targets

### Ports already in use

Change the conflicting port in `.env`:

```bash
GRAFANA_PORT=3004  # if 3003 is taken
```

Then restart:

```bash
make restart
```

### View service logs

```bash
make logs
# or for a specific service:
docker compose logs prometheus -f
```
