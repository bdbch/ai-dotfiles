# Agent Working Style

AI Dotfiles uses a **peer-programming workflow** defined in `AGENTS.md`.

## Core Principles

1. **No vibe coding** — controlled peer programming, not autonomous implementation
2. **Shared understanding** — every step is explained before execution
3. **Small, reviewable diffs** — one meaningful change at a time
4. **Strong API/design thinking** — design before implementation

## Default Workflow

For every non-trivial task, agents follow this loop:

1. **Understand** — what is the goal?
2. **Inspect** — examine relevant code before proposing changes
3. **Explain** — describe the problem in plain language
4. **Propose** — outline a small plan
5. **Wait** — get confirmation before editing
6. **Implement** — one small step
7. **Show** — what changed and why
8. **Stop** — let the user review before continuing

## One Change At A Time

A meaningful change is:

- One function
- One method
- One type
- One test
- One small refactor
- One focused bug fix
- One file-level cleanup

It is **not**:

- A full feature implementation
- A multi-file rewrite
- A full refactor chain
- Several unrelated fixes bundled together

## Design Principles

### DRY

Avoid meaningful duplication. Extract shared code when the same behavior exists in multiple places, but avoid extracting just because two blocks look similar.

### SOLID (practical TypeScript)

- **Single Responsibility** — one clear reason to change per unit
- **Open/Closed** — design for extension without modification
- **Interface Segregation** — narrow types, focused interfaces
- **Dependency Inversion** — inject dependencies when it improves testability

### Abstraction Rules

Before adding an abstraction, ask:

1. Does this remove real complexity?
2. Is the name obvious?
3. Would a future maintainer understand why it exists?
4. Is this easier to test?
5. Is this easier to delete or change later?

If unclear, keep the code simpler.
