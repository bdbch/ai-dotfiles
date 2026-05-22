# Coding Guidelines

This is the central hub for AI-assisted development work. Everything
related to planning, implementation notes, development journals, and
design decisions lives here.

## Purpose

- Keep a running record of what we are working on.
- Document implementation plans before writing code.
- Write development journals after sessions.
- Store design decisions and tradeoff analyses.
- Avoid the vibecoding trap (prompt → error → prompt → error).

## Directory Structure

```
~/ai/
├── README.md       # You are here
├── AGENTS.md       # Agent instructions for this repo
├── CLAUDE.md       # Agent instructions (Claude ecosystem)
└── docs/           # All plans, notes, journals, design docs
    ├── plans/         # General plans for overarching projects
    ├── notes/         # General notes (not project-specific)
    ├── journals/      # General session journals
    └── REPOSITORY_NAME/
        └── BRANCH_NAME/
            ├── plans/
            ├── notes/
            └── journals/
```

## Instruction Files

The following documents define the working conventions for this project:

| File | Purpose |
|------|---------|
| [ANTI_VIBECODE.md](./instructions/ANTI_VIBECODE.md) | Anti-vibecoding ethos and coding cadence |
| [CONVENTIONS_CODING.md](./instructions/CONVENTIONS_CODING.md) | Code styles, standards, and engineering principles |
| [CONVENTIONS_DESIGN.md](./instructions/CONVENTIONS_DESIGN.md) | Design values and visual principles |
| [CONVENTIONS_DOCUMENTATION.md](./instructions/CONVENTIONS_DOCUMENTATION.md) | Documentation conventions for plans, notes, and journals |
| [ENGINEERING_VALUES.md](./instructions/ENGINEERING_VALUES.md) | Engineering culture and developer experience principles |
