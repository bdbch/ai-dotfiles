---
name: "Code Map"
description: "Trace execution flow of a feature from start to finish — entry points, data flow, lifecycle, and Mermaid diagrams."
---

# Code Map

> Trace execution flow of a feature from start to finish — entry points, data flow, lifecycle, and Mermaid diagrams.

## When to use

Use this skill when you need to understand how a feature works from start to finish — the full lifecycle from initialization to teardown.

## How to trace

1. **Find the entry point**: Where does execution start? Constructor, main function, route handler, event listener.
2. **Follow the execution blindly**: Don't assume the path. Read every file you reference.
3. **Grep for lifecycle keywords**: init, setup, start, create, mount, listen, destroy, cleanup, dispose, teardown.
4. **Follow imports and DI**: Trace the full dependency graph.
5. **Note data transformations**: Where does data enter, change shape, and leave?

## Output structure

### Feature Overview
Brief summary of what is being mapped.

### Entry Point
File:line of initialization or trigger.

### Execution Flow
Numbered steps from entry to exit. Each step: file:line and what happens.

### Component Relationships
Parent/child/sibling relationships. Composition, inheritance, DI, event subscription.

### Data Flow
Inputs → processing steps → outputs. State management, caches, side effects.

### Lifecycle
Creation → initialization → active → cleanup/teardown. Hooks, listeners, destruction patterns.

### Mermaid Diagram
Generate a diagram using the appropriate type:
- `flowchart LR` or `flowchart TD` for execution flow
- `sequenceDiagram` for request/response flows
- `classDiagram` for class hierarchies

### Node References
List each node/symbol with file:line for quick navigation.
