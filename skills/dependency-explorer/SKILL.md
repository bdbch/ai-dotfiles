---
name: "Dependency Explorer"
description: "Analyze the dependency graph — circular dependencies, coupling hotspots, health, and bundle implications."
---

# Dependency Explorer

> Analyze the dependency graph — circular dependencies, coupling hotspots, health, and bundle implications.

## When to use

Use this skill when you need to understand the dependency graph — circular deps, coupling hotspots, fan-in/fan-out — or when planning a refactor.

## How to analyze

1. **Start with package manager files**: package.json, Cargo.toml, go.mod, requirements.txt for external deps.
2. **Trace imports**: Grep for import/require/use statements for internal deps.
3. **Build a dependency graph**: For each module, list what it imports and what imports it.
4. **Distinguish type-only vs runtime imports** — type-only deps are safer.
5. **For monorepos**: Trace cross-package dependencies.

## Output structure

### Dependency Graph Overview
Total modules, total dependencies, circular dependency count, health score.

### Circular Dependencies
Each cycle with full path. Modules involved, import chain, suggestion for breaking.

### Hot Modules
Highest fan-in (most consumers) and highest fan-out (most dependencies). Highest-risk to change.

### Health Report
Outdated versions, deprecated packages, security advisories, unmaintained, license concerns.

### Coupling Analysis
Highly coupled modules that should be decoupled. Implementation details vs abstractions.

### Recommendations
Specific actions to reduce coupling or dependency volume, ordered by impact.
