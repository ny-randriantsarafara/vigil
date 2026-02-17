# Observability Stack Details

## Repository structure

- `docker-compose.yml`: stack orchestration
- `prometheus/`: scrape and alert rules
- `loki/`: Loki configuration
- `grafana/provisioning/`: datasources and dashboards
- `scripts/validate.sh`: static and compose validation
- `scripts/smoke.sh`: runtime health checks

## Prometheus templating

Prometheus config is generated at container startup from `prometheus/prometheus.yml.tmpl` using:

- `PROMETHEUS_SCRAPE_TARGET`
- `PROMETHEUS_JOB_NAME`

This keeps the stack reusable across services without editing tracked files.

## Loki retention

Loki retention is injected from `LOKI_RETENTION` at startup via template replacement.

## Grafana linking behavior

Grafana's Loki datasource uses a derived field `TraceID` linked to the datasource UID `jaeger` so log lines containing `traceId` can jump directly to trace views.
