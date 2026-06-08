#!/usr/bin/env bash
set -euo pipefail

# Helper to tail docker compose logs with timestamps.
# Usage:
#   ./scripts/logs.sh              # tails root docker-compose.yml logs
#   ./scripts/logs.sh jenkins     # tails jenkins/docker-compose.yml logs

COMPOSE_FILE="docker-compose.yml"
if [ "$#" -ge 1 ] && [ "$1" = "jenkins" ]; then
  COMPOSE_FILE="jenkins/docker-compose.yml"
fi

docker compose -f "$COMPOSE_FILE" logs -f --no-color | while IFS= read -r line; do
  printf "%s %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$line"
done
