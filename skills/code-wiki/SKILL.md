---
name: "code-wiki"
description: "Explain codebase symbols — Wikipedia-style articles for functions, classes, types, and modules."
---

# Code Wiki

> Explain codebase symbols — Wikipedia-style articles for functions, classes, types, and modules.

## When to use

Use this skill when you need a thorough explanation of a specific function, class, type, or module — including all references, dependencies, and usage patterns.

## How to explain

1. **Read the full source** of the symbol before writing anything.
2. **Grep for all references** — callers, instantiations, imports, test references.
3. **Read the type definitions** — the type system reveals intent.
4. **Check JSDoc, comments, and commit history** for context.
5. **Verify every file:line reference** actually exists.

## Output structure

### Overview
One-paragraph plain-language summary. What does it do? Who uses it? What problem does it solve?

### Declaration
Exact location (file:line), signature, visibility, decorators. Include type signature.

### How It Works
Step-by-step breakdown of internal logic. Key algorithms, control flow, error handling, edge cases.

### API Reference
Parameters with types and defaults. Return value. For classes: constructor, methods, properties, events.

### Usage
Where is this symbol called, instantiated, extended, or referenced? Concrete call sites with file:line.

### Dependencies
What does it import? External libraries? Internal module coupling?

### Related Symbols
Similar functions, parent/child classes, related types, patterns it participates in.

### Context
Why does this exist? What commit, issue, or requirement introduced it?
