# Docker Compose Observability Stack (Grafana, Prometheus, Loki, Jaeger)

Reusable self-hosted observability stack for local development and pre-production environments. This repository helps you run end-to-end monitoring with Prometheus metrics, Loki logs, Jaeger traces, and Grafana dashboards in one Docker Compose setup.

## What this repository provides

- Metrics collection with Prometheus (`/metrics` scraping)
- Centralized log storage and query with Loki
- Distributed tracing with Jaeger via OpenTelemetry OTLP HTTP
- Unified observability dashboards in Grafana with pre-provisioned datasources and dashboards

## Best-fit use cases

- Bootstrap observability for an API or microservice quickly
- Run a local monitoring stack for metrics, logs, and traces
- Validate OpenTelemetry instrumentation end to end
- Demo Grafana correlation between metrics, logs, and trace data

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

## Linux networking note

If `host.docker.internal` does not resolve on your host, keep `extra_hosts` enabled in `docker-compose.yml` (`host.docker.internal:host-gateway`) or set `PROMETHEUS_SCRAPE_TARGET` to an explicit reachable host/IP.

## Documentation

- Getting started: `docs/getting-started.md`
- Overview: `docs/overview.md`
- Technical details: `docs/details.md`

## Validation

```bash
make validate
make smoke
```

`make smoke` assumes the stack is already running.
