#!/usr/bin/env bash
set -euo pipefail

# Host-side cleanup script for demo-shell Docker resources.
# Run this periodically to reclaim disk space.

KEEP_SNAPSHOTS="${1:-6}"

echo "=== Docker disk usage (before) ==="
docker system df

# 1. Remove stopped containers from soosio images
echo ""
echo "--- Pruning stopped containers ---"
docker container prune -f

# 2. Remove dangling (untagged) images
echo ""
echo "--- Removing dangling images ---"
docker image prune -f

# 3. Keep only the N most recent demo-shell snapshots
echo ""
echo "--- Pruning old demo-shell snapshots (keeping ${KEEP_SNAPSHOTS}) ---"
OLD_SNAPSHOTS=$(docker images demo-shell --format '{{.Tag}}' | grep '^snapshot-' | sort -r | tail -n +"$(( KEEP_SNAPSHOTS + 1 ))")
if [ -n "${OLD_SNAPSHOTS}" ]; then
  echo "${OLD_SNAPSHOTS}" | xargs -I{} docker rmi "demo-shell:{}"
else
  echo "No old snapshots to remove."
fi

echo ""
echo "=== Docker disk usage (after) ==="
docker system df
