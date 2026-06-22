# pikoci-demo

A simple Go project used to demonstrate [PikoCI](https://pikoci.com).

## What this does

A basic Go HTTP server with three CI targets:

- `make build` — compile the binary
- `make lint` — run `go vet`
- `make test` — run unit tests

The `pipeline.hcl` defines a PikoCI pipeline that:
1. Runs **build**, **lint**, and **test** in parallel on every pull request
2. Reports status via GitHub Checks
3. Deploys on merge to `main`
