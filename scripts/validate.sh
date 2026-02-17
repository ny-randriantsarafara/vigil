#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

docker compose config >/dev/null

if command -v yamllint >/dev/null 2>&1; then
  mapfile -t yaml_files < <(find . -type f \( -name '*.yml' -o -name '*.yaml' \) -not -path './.git/*' | sort)
  yamllint "${yaml_files[@]}"
else
  echo "yamllint not installed, skipping YAML lint"
fi

echo "validation completed"
