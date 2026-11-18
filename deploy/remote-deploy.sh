#!/usr/bin/env bash
# Runs on the VPS (as the deploy user) from GitHub Actions.
# Usage: remote-deploy.sh <image-tag>
set -euo pipefail

app=sanvir-net
app_dir=/opt/apps/$app
tag=${1:?image tag required}

cd "$app_dir"
printf 'IMAGE_TAG=%s\n' "$tag" > .env

docker compose pull
docker compose up -d --remove-orphans

echo "Waiting for $app to become healthy..."
for _ in $(seq 1 30); do
  status=$(docker inspect -f '{{.State.Health.Status}}' "$app" 2>/dev/null || echo missing)
  [ "$status" = healthy ] && break
  sleep 2
done
if [ "$status" != healthy ]; then
  echo "$app is $status after 60s; recent logs:" >&2
  docker compose logs --tail 50 >&2
  exit 1
fi

install -m 644 "$app.caddy" "/opt/edge/sites/$app.caddy"
docker exec edge-caddy caddy reload --config /etc/caddy/Caddyfile

docker image prune -f >/dev/null
echo "Deployed $app:$tag"
