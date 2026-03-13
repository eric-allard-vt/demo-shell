# Accessing Files Inside the Demo Container

This file is baked into the demo-shell image. It explains where everything is and how to access files from your host machine.

## Path Reference

| Path inside container | What it is | Needs rebuild to update? |
|---|---|---|
| `./demo_files/` | All demo files (SARIF, SBOMs, code, client scenarios) | Yes |
| `./host/` | Your Mac's `~/Documents/demo_mnt/` | No - live mount |
| `./soos/` | SOOS tools (installed at startup) | No - installed fresh each launch |
| `./invocations_example.sh` | Reference script with placeholder credentials | Yes |
| `./demo_files/exports/` | Output directory for scan results | No |

## What's in `./demo_files/`

```
demo_files/
  SARIF/
    gitleaks/               # Gitleaks scan results
    image_resizer/          # Semgrep SARIF output
    msbuild/                # MsBuild SARIF output
    saintcon/               # Saintcon SARIF output
  SBOMs/
    ACME Medical/           # ACME Medical SBOM
    elasticsearch_*.cdx.json
    image-resizer_GITHUB.spdx.json
    image-resizer_testaware_sca.cdx.json
    react-router_v7.13.1.npm.cdx.json
    redis_*.cdx.json
  code/
    image-resizer-master/   # Node.js app for SCA scanning
    c-application/          # C app with header files for hash scanning
  client/
    gehc/                   # GEHC client demo (SBOMs, package.json, pom.xml, dotnet)
  conan_and_hash_scan/      # Conan C/C++ project for manifest + hash scanning
  manifests/                # Kubernetes manifests
  exports/                  # Output directory
```

## Using the Example Script

1. Open the reference script: `cat invocations_example.sh`
2. Set your credentials:
   ```bash
   export SOOS_API_KEY="your-actual-key"
   export SOOS_CLIENT_ID="your-actual-id"
   ```
3. Copy and paste individual commands from the script to run them

## Accessing Files From Your Host Machine

The `./host/` directory is a live mount of `~/Documents/demo_mnt/` on your Mac.

To scan a file from your Mac:
1. Drop the file in `~/Documents/demo_mnt/` (or a subfolder) on your Mac
2. Reference it as `./host/<path>` inside the container
3. No rebuild needed

Example:
```bash
node ./soos/node_modules/@soos-io/soos-sbom/bin/index.js \
    --clientId=$SOOS_CLIENT_ID \
    --apiKey=$SOOS_API_KEY \
    --projectName="Ad-hoc SBOM Scan" \
    "./host/my_new_file.cdx.json"
```

## Quick Rules

- `./demo_files/...` = baked into the image, has everything for standard demos
- `./host/...` = live from your Mac, for ad-hoc or temporary files
- `./invocations_example.sh` = reference script, add your credentials to use
