if exist "./soos" (rmdir /S /Q "./soos")
npm install --prefix ./soos @soos-io/soos-sbom
node ./soos/node_modules/@soos-io/soos-sbom/bin/index.js --apiURL="https://qa-api.soos.io/api/" --clientId=<your-client-id> --apiKey=<your-api-key> --projectName="parent_sbom" ./