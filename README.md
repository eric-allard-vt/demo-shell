# *SOOS Demo Shell*

<img src="https://github.com/eallard-soos/demo-shell/blob/main/demo-shell-logo.webp?raw=true" alt="Demo Shell Logo" width="400"/>

Launch a container with all SOOS apps pre‑installed and ready for demos.

Each time you start a session the helper script pulls the latest versions of the SOOS tools and tags the previous image locally, so you can roll back if needed.

## Handy alias

Add this to your `~/.bashrc` or `~/.zshrc`:

```bash
alias start-demo='docker run -it --rm   -v /var/run/docker.sock:/var/run/docker.sock   -v /absolute/path/on/host:/usr/src/app/exports   demo-shell:latest'
```

Replace `/absolute/path/on/host` with a real directory for exporting results.

### Quick rollback with **local** tags

If a fresh install of SOOS tools breaks your demo, use these commands to locate an earlier **locally‑tagged** image and run it immediately.

#### 1. Show the 10 most‑recent local tags

```bash
# List demo‑shell images, newest first
docker images demo-shell   --format '{{.CreatedAt}}	{{.Tag}}' |   sort -r | head -n 10
```

#### 2. Start a container from a specific tag

```bash
# Replace <tag> with the timestamp you want to roll back to, e.g. 2025-06-17-1032
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock demo-shell:<tag>   bash
```

---

## Cleanup

Over time, `docker pull` and container scans leave behind dangling images and stopped containers. Use the cleanup script to reclaim disk space:

```bash
# From the host, run the cleanup script (keeps 6 most recent snapshots by default)
./cleanup-demo.sh

# Keep a different number of snapshots
./cleanup-demo.sh 3
```

The `init-demo-env.sh` script also prunes dangling images automatically at the start of each session.

For a one-time deep clean:

```bash
docker container prune -f
docker image prune -f
```

---

## To build the image locally

```bash
docker build -t demo-shell:latest .
```

## Push the image to Docker Hub

```bash
# Tag the local image with your Docker Hub repo name
docker tag demo-shell:latest ericallard/demo-shell:latest
docker login                 # first-time only
docker push ericallard/demo-shell:latest
```

### Push a tagged version

```bash
docker tag demo-shell:latest ericallard/demo-shell:YYYY-MM-DD # replace dates
docker push ericallard/demo-shell:YYYY-MM-DD
```