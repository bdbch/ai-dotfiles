---
name: "API Surface"
description: "Map all public exports, endpoints, CLI commands, configuration points, and events."
---

# API Surface

> Map all public exports, endpoints, CLI commands, configuration points, and events.

## When to use

Use this skill when you need a complete inventory of what a module, package, or system exposes publicly — for design, migration, or documentation.

## How to map

1. **Find entry points**: package.json exports/main, index files, server entry points, CLI entry points.
2. **For exports**: Grep for export statements in entry points.
3. **For API endpoints**: Look for route definitions (Express, Fastify, Next.js API routes, tRPC, GraphQL).
4. **For CLI commands**: Look for command definitions (commander, yargs, clap, cobra).
5. **For config**: Look for config loading, env var reading, runtime config objects.
6. **For events**: Look for EventEmitter, emit, dispatch, publish patterns.

## Output structure

### Public Exports
All exported symbols from entry points. Name, type (function/class/type/const), file:line, JSDoc presence.

### API Endpoints
All HTTP routes: method, path, request params, request body type, response type, auth requirements.

### CLI Interface
All commands, subcommands, flags, arguments, env vars. Description, type, default, required/optional.

### Configuration Surface
Config files, env vars, runtime options. Path, schema/shape, defaults.

### Events
Emitted event names, payload types, emitter locations, known listeners.

### Documentation Gaps
Public symbols lacking JSDoc or type documentation — riskiest to change.
