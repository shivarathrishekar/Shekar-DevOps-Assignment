# DevOps Assignment

Containerized Python service, Helm chart, Kubernetes setup, and debugging lab.

## Application
- GET / returns app name, version, and pod hostname as JSON.
- GET /healthz returns HTTP 200.

## Validation
Run helm lint .\chart and helm template demo .\chart from the repository root.

## Security
The container runs as a non-root user. Review security, monitoring, TLS, and access controls before production use.

## AI assistance
AI assistance was used during development. Verify all code and test results before submission.

## Limitations
Report only tests actually executed and document unfinished work honestly.
