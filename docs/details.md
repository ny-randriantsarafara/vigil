# Observability Stack Technical Details

## Repository structure

- `docker-compose.yml`: local stack orchestration for Grafana, Prometheus, Loki, and Jaeger
- `prometheus/`: Prometheus scrape configuration and alert rules
- `loki/`: Loki configuration and retention setup
- `grafana/provisioning/`: Grafana datasource and dashboard provisioning
- `scripts/validate.sh`: static configuration and Docker Compose validation
- `scripts/smoke.sh`: runtime health checks for stack services

## Prometheus configuration templating

Prometheus config is generated at container startup from `prometheus/prometheus.yml.tmpl` using:

- `PROMETHEUS_SCRAPE_TARGET`
- `PROMETHEUS_JOB_NAME`

This templating model keeps the monitoring stack reusable across multiple services without editing tracked files.

## Loki retention configuration

Loki retention is injected from `LOKI_RETENTION` at startup through template replacement.

## Grafana logs-to-traces linking

Grafana's Loki datasource defines a derived field `TraceID` linked to datasource UID `jaeger`, so log lines containing `traceId` can open the related distributed trace view directly.
