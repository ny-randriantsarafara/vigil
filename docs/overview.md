# Observability Stack Overview (Metrics, Logs, Traces)

This repository provides a reusable Docker Compose observability stack for services that expose Prometheus metrics and emit structured logs and traces.

## Core components

- Prometheus: scrapes and stores time-series application metrics
- Loki: stores and queries structured logs
- Jaeger: ingests and visualizes distributed traces
- Grafana: centralized dashboards across metrics, logs, and traces

## End-to-end data flow

1. Prometheus scrapes `http://<target>/metrics`
2. Your application pushes logs to Loki through `LOKI_URL`
3. Your application exports traces to Jaeger through `OTEL_EXPORTER_OTLP_ENDPOINT`
4. Grafana queries Prometheus, Loki, and Jaeger for unified observability views

## Pre-provisioned dashboards

- `Service API Overview`: HTTP and runtime monitoring dashboard template
- `Business Metrics Template`: domain KPI dashboard template
