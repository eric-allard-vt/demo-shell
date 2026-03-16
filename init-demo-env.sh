#!/usr/bin/env bash
set -euo pipefail

# Match the Docker API version of the host's Docker Engine
export DOCKER_API_VERSION=1.43

IMAGE_NAME="demo-shell"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

############################################
# 0) Prune dangling images from prior pulls
############################################
docker image prune -f

############################################
# 1) Install / pull the latest SOOS tools
############################################
[ -d "./soos" ] && rm -rf "./soos"
npm install --prefix ./soos @soos-io/soos-sca
npm install --prefix ./soos @soos-io/soos-sbom
npm install --prefix ./soos @soos-io/soos-sast

docker pull soosio/dast
docker pull soosio/csa
docker pull soosio/sast

############################################
# 2) Commit the *running* container
############################################
# This docker commit works because we mounted the host’s Docker socket when we launched the container
CONTAINER_ID=$(hostname)
SNAPSHOT_TAG="snapshot-${TIMESTAMP}"

docker commit "${CONTAINER_ID}" "${IMAGE_NAME}:${SNAPSHOT_TAG}"
echo "Snapshot saved as ${IMAGE_NAME}:${SNAPSHOT_TAG}"

############################################
# 3) Drop into an interactive shell
############################################
exec bash