# Observability Stack Overview

This repository hosts an independent observability stack for any service exposing Prometheus metrics and structured logs/traces.

## Components

- Prometheus: scrapes application metrics
- Loki: stores and queries logs
- Jaeger: receives and visualizes traces
- Grafana: dashboards and cross-linking between metrics, logs, and traces

## Data flow

1. Prometheus scrapes `http://<target>/metrics`
2. Application pushes logs to Loki (`LOKI_URL`)
3. Application exports traces to Jaeger (`OTEL_EXPORTER_OTLP_ENDPOINT`)
4. Grafana queries Prometheus/Loki/Jaeger

## Pre-provisioned dashboards

- `Service API Overview`: generic HTTP/runtime metrics
- `Business Metrics Template`: example dashboard for domain metrics
