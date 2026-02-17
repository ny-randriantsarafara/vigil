#!/usr/bin/env bash
set -euo pipefail

check_url() {
  local name="$1"
  local url="$2"
  local max_attempts="${3:-12}"
  local sleep_seconds="${4:-5}"
  local attempt=1

  while [ "$attempt" -le "$max_attempts" ]; do
    if curl -fsS "$url" >/dev/null; then
      echo "$name healthy"
      return 0
    fi

    if [ "$attempt" -eq "$max_attempts" ]; then
      echo "$name health check failed after ${max_attempts} attempts: $url"
      return 1
    fi

    attempt=$((attempt + 1))
    sleep "$sleep_seconds"
  done
}

PROMETHEUS_PORT="${PROMETHEUS_PORT:-9090}"
GRAFANA_PORT="${GRAFANA_PORT:-3003}"
LOKI_PORT="${LOKI_PORT:-3100}"
JAEGER_UI_PORT="${JAEGER_UI_PORT:-16686}"

check_url "Prometheus" "http://localhost:${PROMETHEUS_PORT}/-/healthy"
check_url "Grafana" "http://localhost:${GRAFANA_PORT}/api/health"
check_url "Loki" "http://localhost:${LOKI_PORT}/ready" 20 3
check_url "Jaeger" "http://localhost:${JAEGER_UI_PORT}/"
