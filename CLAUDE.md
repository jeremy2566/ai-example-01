# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Development
- `yarn install` - Install dependencies
- `yarn start` - Start the server (runs on port 3001)
- `yarn dev` - Start the server with auto-reload using nodemon

### Docker
- Build image: `docker build -t ai-example-01 .`
- Run container: `docker run -p 3001:3001 ai-example-01`

### Helm Chart
- Package chart: `helm package ai-example-01/`
- Deploy: `helm install ai-example-01 ./ai-example-01`
- Upgrade: `helm upgrade ai-example-01 ./ai-example-01`

## Architecture

This is a containerized Node.js Express web service with Kubernetes deployment via Helm:

1. **Application Layer** (`index.js`)
   - Simple Express server on port 3001
   - Single endpoint at `/` returning JSON status message
   - No authentication or middleware beyond JSON parsing

2. **Container Layer** (`Dockerfile`)
   - Based on Node 18 Alpine Linux
   - Runs as non-root user
   - Production optimized with layer caching

3. **Kubernetes Layer** (`ai-example-01/` Helm chart)
   - Deployment configured for AWS ECR image repository
   - Service exposes port 80 internally, maps to container port 3001
   - Health checks configured on root endpoint
   - Optional HPA, Ingress, and ServiceAccount resources

4. **CI/CD** (`.github/workflows/aws-ecr-publish.yaml`)
   - GitHub Actions workflow for ECR deployment (currently incomplete)

## Key Configuration Points

- Application port: 3001 (hardcoded in `deployment.yaml`, configurable via `PORT` env var in app)
- ECR repository: `858157298152.dkr.ecr.ap-southeast-1.amazonaws.com/hanzhang/ai-example-01`
- Health endpoint: `/` (used for liveness and readiness probes)