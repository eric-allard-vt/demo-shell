# SOOS Demo Shell - Example Invocations
#
# This is a reference script showing how to run various SOOS scans.
# Replace the placeholder credentials below with your own before running.
#
# All demo files referenced below are included in this container under ./demo_files/
# For ad-hoc scans of files on your host machine, use the ./host/ mount point.
# See CONTAINER_FILE_ACCESS.md for details.

# setopt interactivecomments

export SOOS_API_KEY="<your-api-key>"
export SOOS_CLIENT_ID="<your-client-id>"

export SONAR_TOKEN="<your-sonar-token>"

export SOOS_API_URL="https://api.soos.io/api/"
#export SOOS_API_URL="https://qa-api.soos.io/api/"

# Container - example of a task you would run in your build agent to
# import container scan results using a Docker container
docker run --platform linux/amd64 -d soosio/csa \
--clientId=$SOOS_CLIENT_ID \
--apiKey=$SOOS_API_KEY \
--apiURL=$SOOS_API_URL \
--projectName="elasticsearch:x86 - Container Scan" ericallard/elasticsearch:x86

docker run --platform linux/amd64 -it soosio/csa \
--clientId=$SOOS_CLIENT_ID \
--apiKey=$SOOS_API_KEY \
--apiURL=$SOOS_API_URL \
--projectName="ruby:alpine3.18 - Container Scan" ruby:alpine3.18

# SAST / Code Issues - example of a task you would run
# in your build agent to import SAST results into the SOOS
node ./soos/node_modules/@soos-io/soos-sast/bin/index.js \
--clientId=$SOOS_CLIENT_ID \
--apiKey=$SOOS_API_KEY \
--projectName="MsBuild Results - SAST Scan" \
--apiURL=$SOOS_API_URL \
--sourceCodePath "./demo_files/SARIF/msbuild"
#--branchName="test branch" \

node ./soos/node_modules/@soos-io/soos-sast/bin/index.js \
--clientId=$SOOS_CLIENT_ID \
--apiKey=$SOOS_API_KEY \
--apiURL=$SOOS_API_URL \
--branchName="main" \
--projectName="java-application" \
--sourceCodePath "./demo_files/SARIF/image_resizer"

# DAST
docker run --platform linux/amd64 -it --rm soosio/dast \
--clientId=$SOOS_CLIENT_ID \
--apiKey=$SOOS_API_KEY \
--apiURL=$SOOS_API_URL \
--projectName="Web App - DAST Scan" \
http://www.example.com

#SBOM
node ./soos/node_modules/@soos-io/soos-sbom/bin/index.js \
--clientId=$SOOS_CLIENT_ID \
--apiKey=$SOOS_API_KEY \
--apiURL=$SOOS_API_URL \
--projectName="ACME Medical - Bedside Monitor - SBOM Scan" \
"./demo_files/SBOMs/ACME Medical/acme_medical_sbom.cdx.json"

# SCA Scan of C headers
node ./soos/node_modules/@soos-io/soos-sca/bin/index.js \
  --clientId=$SOOS_CLIENT_ID \
  --apiKey=$SOOS_API_KEY \
  --apiURL=$SOOS_API_URL \
  --sourceCodePath "./demo_files/code/c-application" \
  --fileMatchType=FileHash \
  --projectName="c-app - Header Files Scan"

# # # 8 project line of demarcation # # #

#SBOM - react router
node ./soos/node_modules/@soos-io/soos-sbom/bin/index.js \
--clientId=$SOOS_CLIENT_ID \
--apiKey=$SOOS_API_KEY \
--apiURL=$SOOS_API_URL \
--projectName="react-router - only direct deps - SBOM Scan" \
"./demo_files/SBOMs/react-router_v7.13.1.npm.cdx.json"

#SBOM - image resizer SBOM w/only direct deps
node ./soos/node_modules/@soos-io/soos-sbom/bin/index.js \
--clientId=$SOOS_CLIENT_ID \
--apiKey=$SOOS_API_KEY \
--apiURL=$SOOS_API_URL \
--projectName="image-resizer - only direct deps - SBOM Scan" \
"./demo_files/SBOMs/image-resizer_testaware_sca.cdx.json"

# # # # # # # # # # # # #
#
#
#
# OTHER STUFF
# Semgrep - Generate SARIF output - run in source dir
docker run --rm -v "${PWD}:/src" returntocorp/semgrep semgrep scan --config auto --sarif > image_resizer_semgrep_output.sarif.json
docker run --rm -v "${PWD}:/src" returntocorp/semgrep semgrep scan --config auto --sarif > semgrep_output.sarif.json

# Generate an SBOM
node ./soos/node_modules/@soos-io/soos-sca/bin/index.js \
  --clientId=$SOOS_CLIENT_ID \
  --apiKey=$SOOS_API_KEY \
  --sourceCodePath "./demo_files/code/image-resizer-master" \
  --projectName="SCA Scan" \
  --exportFormat="CycloneDx" \
  --exportFileType="json" \
  --outputDirectory="/usr/src/app/exports"

echo $SOOS_CLIENT_ID
echo $SOOS_API_KEY

# GitHub contrib dev audit
node ./soos/node_modules/@soos-io/soos-scm-audit/bin/index.js \
--apiKey=$SOOS_API_KEY \
--clientId=$SOOS_CLIENT_ID \
--scmType=GitHub \
--secret="<your-github-token>" \
--organizationName="soos-io-demo" \
--saveResults

# SCA Scan
node ./soos/node_modules/@soos-io/soos-sca/bin/index.js \
  --clientId=$SOOS_CLIENT_ID \
  --apiKey=$SOOS_API_KEY \
  --sourceCodePath "./demo_files/code/image-resizer-master" \
  --onFailure="fail_the_build" \
  --projectName="SCA Scan fail build"

docker run -d  \
soosio/csa --clientId=$SOOS_CLIENT_ID \
--apiKey=$SOOS_API_KEY \
--projectName="soosio/dast" soosio/dast

# gitleaks (secrets scanner)
# Mount a git repo from your host via ./host/ and scan it
# With this syntax, point to a path that's a git repo or it won't work
docker run -v "./host/lots-o-secrets:/path" -v \
"./host/output:/output" zricethezav/gitleaks:latest \
detect \
--source="/path" \
--report-format sarif \
--report-path /output/gitleaks_result.sarif.json \
--log-level debug

# without additional explicit bind to output folder, just write to /path in scanned directory
# with this syntax point to a path that's a git repo or it won't work
docker run -v "./host/lots-o-secrets:/path" zricethezav/gitleaks:latest \
detect \
--source="/path" \
--config="/path/gitleaks.toml" \
--report-format sarif \
--report-path /path/gitleaks_scan_result.json \
--log-level debug

docker run -it --rm soosio/dast \
--clientId=$SOOS_CLIENT_ID \
--apiKey=$SOOS_API_KEY \
--branchName="main" \
--projectName="Java App - SCA & DAST Scan" \
http://www.example.com

node ./soos/node_modules/@soos-io/soos-sast/bin/index.js \
--clientId=$SOOS_CLIENT_ID \
--apiKey=$SOOS_API_KEY \
--branchName="main" \
--projectName="Java App - SCA & DAST Scan" \
--sourceCodePath "./demo_files/SARIF/image_resizer"

curl -X GET "https://api-stats.soos.io/api/enterprise/clients/$SOOS_CLIENT_ID/package-managers/npm/package-attributions/cycloneDx?packageId=axios&packageVersion=0.20.0&includeVulnerabilities=true" \
-H "accept: application/json" -H "x-soos-apikey: $SOOS_API_KEY"

docker run --platform linux/amd64 -it soosio/csa \
--clientId=$SOOS_CLIENT_ID \
--apiKey=$SOOS_API_KEY \
--projectName="ruby:alpine3.18" us-east4-docker.pkg.dev/forbes-production/containers/simple-site/production:a7ad2edddc222c7e0daccbe57f82fe06ad03403068e7d4ad34770f6ccd75efb2

docker run --platform linux/amd64 -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  soosio/csa \
  --clientId=$SOOS_CLIENT_ID \
  --apiKey=$SOOS_API_KEY \
  --projectName="ruby:alpine3.18" us-east4-docker.pkg.dev/forbes-production/containers/simple-site/production:a7ad2edddc222c7e0daccbe57f82fe06ad03403068e7d4ad34770f6ccd75efb2

# SOOSTER Video Content
node ./soos/node_modules/@soos-io/soos-sast/bin/index.js \
--clientId=$SOOS_CLIENT_ID \
--apiKey=$SOOS_API_KEY \
--projectName="Chicksum Analyser" \
--sourceCodePath "./demo_files/SARIF/msbuild"

# opengrep W/OUT .git dir
# Mount source code from your host via ./host/ for scanning
docker run -u soos -v ./host/opengrep_test_no_git:/home/soos/wrk/:rw \
--rm soosio/sast --sarifGenerator opengrep \
--apiKey "$SOOS_API_KEY" \
--clientId "$SOOS_CLIENT_ID" \
--projectName "OpenGrep - No git folder"

# opengrep WITH .git dir
docker run -u soos -v ./host/opengrep_test_with_git:/home/soos/wrk/:rw \
--rm soosio/sast --sarifGenerator opengrep \
--apiKey "$SOOS_API_KEY" \
--clientId "$SOOS_CLIENT_ID" \
--projectName "OpenGrep - With git folder"

# SONAR TESTING

# to hit the sonar server from the demo container
# http://host.docker.internal:9000

#docker version of sonar scanner
docker run --rm \
  -e SONAR_HOST_URL="http://host.docker.internal:9000" \
  -e SONAR_TOKEN="$SONAR_TOKEN" \
  -v "./demo_files:/usr/src" \
  sonarsource/sonar-scanner-cli \
  -Dsonar.projectKey=ERA-Sonar-Proj \
  -Dsonar.projectBaseDir=/usr/src \
  -Dsonar.sources=.

  # run SOOS SAST with Sonar pull
docker run -u soos -v --it --rm soosio/sast \
  --sarifGenerator sonarqube \
  --otherOptions "--url http://host.docker.internal:9000 --token $SONAR_TOKEN -k ERA-Sonar-Proj" \
  --apiKey "$SOOS_API_KEY" \
  --clientId "$SOOS_CLIENT_ID" \
  --projectName "ERA-TEST (SonarQube)"
