---
name: "terminal-support"
description: "Run dev workflow — tests, linting, type-checking, builds, formatting, dependency installation."
---

# Terminal Support

> Run dev workflow — tests, linting, type-checking, builds, formatting, dependency installation.

## When to use

Use this skill when you need to run development tasks in the terminal: tests, linting, type-checking, builds, formatting, or installing dependencies.

## Supported workflows

### Run tests
Detect test runner (jest, vitest, pytest, cargo test) and run. Report: total, passed, failed, failing test names with errors.

### Run linting
Detect linter (ESLint, ruff, clippy) and run. Report: warnings, errors, key findings.

### Type check
Run type checker (TypeScript, mypy). Report: number and location of type errors.

### Build
Run project build. Report: success or failure with relevant error output.

### Format code
Run formatter (Prettier, ruff format, rustfmt) on project or subset.

### Install dependencies
Detect package manager (npm, pip, cargo, go mod) and install.

### Run custom scripts
Run any npm/pip/cargo script or Makefile target.

## Principles
- Detect tooling automatically from project config files
- Report results clearly and concisely
- Show failing test name and error, not full log
- Suggest next steps based on error output
- Never modify files — only execute existing commands
- Prefer existing project scripts over raw tool invocations
