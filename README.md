# Observability Stack

Reusable Docker Compose observability stack with Grafana, Prometheus, Loki, and Jaeger.

## What this repository provides

- Metrics collection via Prometheus (`/metrics` scraping)
- Logs storage/search via Loki
- Traces visualization via Jaeger (OTLP HTTP endpoint)
- Unified dashboards in Grafana with pre-provisioned datasources and dashboards

## Runtime contract with your application

Your application must expose:

- `GET /metrics`
- `GET /health/live` and `GET /health/ready` (recommended)

Your application can optionally send:

- Logs to `LOKI_URL` (default local target: `http://localhost:3100`)
- Traces to `OTEL_EXPORTER_OTLP_ENDPOINT` (default local target: `http://localhost:4318`)

## Quick start

```bash
cp .env.example .env
make up
```

Then open:

- Grafana: `http://localhost:3003` (`GRAFANA_PORT`)
- Prometheus: `http://localhost:9090` (`PROMETHEUS_PORT`)
- Loki: `http://localhost:3100` (`LOKI_PORT`)
- Jaeger: `http://localhost:16686` (`JAEGER_UI_PORT`)

## Configuration

Set values in `.env` (see `.env.example`):

- `PROMETHEUS_SCRAPE_TARGET` (default `host.docker.internal:3001`)
- `PROMETHEUS_JOB_NAME` (default `application-api`)
- `GRAFANA_PORT` (default `3003`)
- `PROMETHEUS_PORT` (default `9090`)
- `LOKI_PORT` (default `3100`)
- `JAEGER_UI_PORT` (default `16686`)
- `JAEGER_OTLP_HTTP_PORT` (default `4318`)
- `PROMETHEUS_RETENTION` (default `15d`)
- `LOKI_RETENTION` (default `168h`)

## Linux note

If `host.docker.internal` does not resolve on your host, keep `extra_hosts` enabled in `docker-compose.yml` (`host.docker.internal:host-gateway`) or set `PROMETHEUS_SCRAPE_TARGET` to an explicit reachable host/IP.

## Validation

```bash
make validate
make smoke
```

`make smoke` assumes the stack is already running.
