---
name: "Deployment"
description: "Design and manage deployments — CI/CD pipelines, Docker, zero-downtime strategies, rollback plans, environment management, and release automation."
---

# Deployment

> Design and manage deployments — CI/CD pipelines, Docker, zero-downtime strategies, rollback plans, environment management, and release automation.

## When to use

Use this skill when planning a deployment strategy, writing CI/CD configurations, designing Docker images, managing environments, or preparing a release. Also use when troubleshooting deployment failures or planning rollbacks.

## Core principles

- **Deployments should be boring** — if deploying is exciting, something is wrong. Automate everything.
- **Environments should be as identical as possible** — every difference between dev and prod is a risk.
- **Deploy forward, roll back cleanly** — the same process that deploys a new version should be able to deploy the old version.
- **Make irreversible changes last** — database schema changes, data migrations, and config changes should be deployable independently.

## CI/CD pipeline

### Pipeline stages

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌──────────┐   ┌──────────┐
│  Lint   │ → │  Build  │ → │  Test   │ → │  Deploy  │ → │  Verify  │
│ & Type  │   │         │   │ (unit,  │   │  (staging│   │ (smoke   │
│  Check  │   │         │   │  int.)  │   │   → prod)│   │  tests)  │
└─────────┘   └─────────┘   └─────────┘   └──────────┘   └──────────┘
```

### Best practices

- **Fail fast:** Fast checks (lint, type, unit tests) run first. If they fail, stop the pipeline.
- **Deterministic builds:** Same commit + same config = same artifact. Use lockfiles, pinned base images.
- **Immutable artifacts:** Build once, promote through environments. Don't rebuild for each environment.
- **Caching:** Cache dependencies (npm, pip, go modules, Docker layers) to speed up pipelines.
- **Secrets:** Never hardcode secrets. Use CI/CD secrets vaults or external secret managers.

### Example CI workflow (GitHub Actions)

```yaml
name: CI/CD
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm run lint
      - run: npm run type-check
      - run: npm test -- --coverage

  build:
    needs: check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: build
          path: dist/

  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
      - run: ./deploy.sh
```

## Docker

### Multi-stage builds

```dockerfile
# Stage 1: Build
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# Stage 2: Production (minimal image)
FROM node:22-alpine
WORKDIR /app
RUN apk add --no-cache tini
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
USER node
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "dist/index.js"]
```

### Dockerfile best practices

```dockerfile
# Order layers by change frequency (least-changing first)
# 1. OS packages (rarely change)
# 2. Dependency files (change with requirements)
# 3. Source code (changes most often)
# This maximizes layer caching

# Use specific tags, not `latest`
FROM node:22-alpine  # Good
FROM node:latest     # Bad — non-deterministic

# Don't run as root
USER myuser

# Use tini for proper signal handling
ENTRYPOINT ["/sbin/tini", "--"]

# Multi-stage keeps images small
# Scan for vulnerabilities
```

## Zero-downtime deployment strategies

### Rolling update

```
Traffic → [v1] [v1] [v1] [v1] [v1]
             ↓
Traffic → [v2] [v1] [v1] [v1] [v1]
             ↓
Traffic → [v2] [v2] [v1] [v1] [v1]
             ↓ ...
Traffic → [v2] [v2] [v2] [v2] [v2]

Best for: Stateless services, gradual rollouts
Pros: No additional infrastructure, gradual
Cons: Mixed versions during deploy, slow rollback
```

### Blue/green

```
Before:                      After:
Traffic → [blue: v1]         Traffic → [green: v2]
          [blue: v1]                   [green: v2]

Route: blue (live)           Route: green (live)
       green (idle)                 blue (old, kept for rollback)

Best for: Critical services, stateful apps with careful migration
Pros: Instant switch, fast rollback (switch back)
Cons: Double infrastructure cost during deploy
```

### Canary

```
Traffic → [v1 (90%)] [v1 (90%)] [v1 (90%)] [v2 (10%)]
                                          ↑ small % receives new version
After validation:
Traffic → [v2 (100%)] after incremental increase

Best for: High-traffic services, risk-sensitive deploys
Pros: Real traffic validation, minimal blast radius
Cons: Complex routing, needs observability to auto-promote/rollback
```

## Rollback strategies

| Strategy | Speed | Risk | When to use |
|----------|-------|------|-------------|
| **Re-deploy previous version** | Medium | Low — same artifact | Standard approach |
| **Blue/green switch** | Fast | Low — instant | If blue/green infra exists |
| **Database rollback** | Slow | High — data loss risk | Only if schema migration failed |
| **Feature flag toggle** | Instant | Low — no deploy needed | For feature-flagged changes |
| **Git revert** | Medium | Medium — new commit | For source-only changes |

### Rollback checklist

```
[ ] 1. Stop the deploy pipeline (prevent further damage)
[ ] 2. Deploy the previous known-good version
[ ] 3. Verify the rollback: is the system healthy?
[ ] 4. Check data integrity (especially if migrations ran)
[ ] 5. Communicate: status, ETA, root cause
[ ] 6. Post-mortem: what went wrong, how to prevent
```

## Environment management

```
Environment     Purpose                Configuration
──────────────  ─────────────────────  ─────────────────────────
dev             Local development      Developer machine, dev DB
staging         Pre-production testing  Separate resources, prod-like
production      Live user traffic       HA, monitoring, alerts, backups
```

### Environment parity

| Aspect | Same everywhere? | Common gap |
|--------|-----------------|------------|
| OS/runtime | ✅ Should be | Using different OS in dev vs prod |
| Dependencies | ✅ Pin versions | `npm install` vs `npm ci` differences |
| Database | ⚠️ Same engine, smaller data | Using SQLite in dev, Postgres in prod |
| Secrets | ❌ Use different values | Using prod secrets in dev (security risk) |
| Configuration | ⚠️ Same structure | Different env var names across envs |

### Configuration management

```yaml
# config.yaml — template with env var substitution
server:
  port: ${PORT:3000}
  host: ${HOST:0.0.0.0}

database:
  url: ${DATABASE_URL}
  max_connections: ${DB_MAX_CONNS:20}

# Secrets never in config files — use vault/env vars
```

## Release automation

### Semantic versioning

```
MAJOR.MINOR.PATCH

1.2.3
│ │ │
│ │ └── Patch: backwards-compatible bug fix
│ └──── Minor: backwards-compatible new feature
└────── Major: breaking change
```

### Release checklist

```markdown
## Release v1.2.3

### Pre-release
- [ ] All PRs for this release are merged
- [ ] Changelog is updated
- [ ] Version bumped in source
- [ ] Release branch created (release/v1.2.3)
- [ ] CI passes on release branch
- [ ] Migration tested on staging
- [ ] Smoke tests pass on staging

### Release
- [ ] Tag created (v1.2.3)
- [ ] Deploy to production
- [ ] Smoke tests pass on production
- [ ] Monitoring dashboards green

### Post-release
- [ ] Merge release branch to main
- [ ] Announce release
- [ ] Document any known issues or migration steps
```

## Deployment anti-patterns

- **Deploying on Friday afternoon:** If something goes wrong, nobody's around to fix it. Deploy early in the week.
- **Manual deployment steps:** Every manual step will be forgotten or done wrong during an incident.
- **Database changes with code changes:** Schema changes and application changes in the same deploy increase risk.
- **No rollback plan:** If you don't know how to roll back, you shouldn't deploy.
- **Skipping staging:** *"It works on my machine"* is not a deployment strategy.
- **Ignoring migration warnings:** Backward-incompatible schema changes cause production outages.
- **Config in code:** Configuration changes shouldn't require a full deploy.

## Monitoring a deployment

Watch these signals during and after a deploy:

| Signal | What to look for |
|--------|-----------------|
| Error rate | Spike after deploy? |
| Response time | Slower after deploy? |
| Throughput | Dropping requests after deploy? |
| Resource usage | CPU/memory higher than expected? |
| Business metrics | Orders, signups, etc. dropping? |
| Logs | New error patterns? |

**Alert threshold:** 5% increase in error rate or response time should trigger investigation.

## Reference

- [The Twelve-Factor App](https://12factor.net/) — methodology for building deployable apps
- [Continuous Delivery](https://continuousdelivery.com/) — Jez Humble & Dave Farley
- [Docker Best Practices](https://docs.docker.com/build/building/best-practices/)
- [Semantic Versioning](https://semver.org/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
