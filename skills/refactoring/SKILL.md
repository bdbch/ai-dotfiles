---
name: "Refactoring"
description: "Refactor, simplify, and restructure code — extract methods, rename symbols, split files, reduce complexity."
---

# Refactoring

> Refactor, simplify, and restructure code — extract methods, rename symbols, split files, reduce complexity.

## When to use

Use this skill when code needs structural improvement: better naming, smaller functions, clearer module boundaries, reduced complexity, or file splitting.

## Core principles

- Never change behavior and structure simultaneously
- One atomic change at a time — checkpoint after each
- Always read the full file before making changes
- Run tests between each step
- Preserve existing API contracts

## Refactoring patterns

### Extract Method / Function
Take a block of code within a function and extract it into a named function.

### Rename Symbol
Rename a function, variable, class, type, or module. Update all references.

### Move to File
Move a function, type, or class from one file to another. Update all imports.

### Introduce Parameter Object
When a function takes 3+ related parameters, group them into a parameter object.

### Split Loop
When a single loop does two different things, split it into two loops.

### Replace Temp with Query
Extract the expression behind a temporary variable into a function.

### Preserve Whole Object
When a function takes several values from an object, pass the object itself.

## Simplification patterns

### 1. Early returns / guard clauses
Replace nested if-else chains with guard clauses that return early.

### 2. Extract boolean expressions
Extract complex conditions into well-named boolean variables or functions.

### 3. Replace conditionals with lookup tables
Replace if-else chains that map keys to values with objects or Maps.

### 4. Remove unnecessary abstraction
Delete wrapper functions that just delegate, unnecessary interfaces with one implementation.

### 5. Flatten nested logic
Restructure deeply nested callbacks, promise chains, or try-catch blocks.

### 6. Replace mutation with pure expressions
Replace variable mutation chains with pure expressions or method chaining.

## Restructuring patterns

### Split by Responsibility
Group related functions, types, and utilities into separate modules. "If you can describe it with 'and', split it."

### Create a Core Module
Extract core business logic into its own module, leaving framework glue separate.

### Extract Utilities
Move generic utility functions into a utils/ module. Ensure they are truly generic.

### Extract Types
Move type definitions, interfaces, enums into a types/ module.

### Create Barrel Exports
Generate index files that re-export the public API of restructured modules.

## What to do before coding

1. Read the full file and understand the behavior
2. Start with an impact analysis — understand what depends on this code
3. If tests exist, run them first. If not, add characterization tests first
4. Present a brief plan before executing complex refactors
