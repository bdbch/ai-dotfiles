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
ai/
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

## Documentation Conventions

Agents working in this repo should write three kinds of documents
when relevant, stored under `docs/`:

### Plans

**When:** Before starting larger work — refactors, multi-file
implementations, complex bugfixes, or any task that benefits from
structured thinking.

**Convention:** Always break plans into phases and sub-phases. Each
phase should be independently reviewable. Include tradeoffs, rejected
alternatives, and verification steps per phase.

**Location:** `docs/REPOSITORY_NAME/BRANCH_NAME/plans/`

### Notes

**When:** Any information worth storing for later — design decisions,
API observations, dependency gotchas, configuration details.

**Convention:** Keep notes concise and factual. One topic per file.
Use notes as a scratchpad for things that don't fit in a plan or
journal.

**Location:** `docs/REPOSITORY_NAME/BRANCH_NAME/notes/` for project-
specific notes, or `docs/notes/` for general notes.

### Journals

**When:** During or after a session. Write as you go — between tasks,
after completing a meaningful change, or at session end. Do not wait
until the end of the day.

**Convention:** Brief and decision-focused. What was done, why, what
was learned, what is next. No fluff.

**Location:** `docs/REPOSITORY_NAME/BRANCH_NAME/journals/` for
project-specific sessions, or `docs/journals/` for general sessions.

### Naming

All document filenames follow this pattern:

```
YYYY-MM-DD-short-descriptive-name.md
```

Examples: `2026-05-21-add-search-index.md`, `2026-05-21-api-rate-limits.md`

## Anti-Vibecoding Ethos

No blind prompting. No "just send the error back" loops.

Before writing code: plan. After writing: review. Every meaningful
change starts with understanding and ends with verification.

Think with me, not for me.

## Engineering Values

### Clean Code

Code must be easy to read and understand at a glance. No long if/else
chains, no deeply nested conditionals, no mile-long switch cases.
Every function should do one thing and do it well — if a function
needs a scrollbar, split it.

### SOLID and DRY

Single responsibility, open/closed, Liskov substitution, interface
segregation, dependency inversion — as practical guidelines, not
dogma. Avoid meaningful duplication. Extract shared logic when the
abstraction has a clear name and purpose. Do not extract just because
two blocks look similar.

### Modularity

Move things apart. Small files, focused utilities, narrow interfaces.
A module should be easy to delete or replace. Prefer composition over
inheritance. Make invalid states hard to represent.

### Developer Experience

If another developer (or my future self) hates reading the code, it
is bad code. Always strive for the best solution — not the fastest
one, not the cleverest one. The solution that is clearest, most
predictable, and easiest to change.

### I Want to Be a Better Developer

Agentic coding should accelerate my learning, not replace it. I do
not want to lose my coding skills because I outsource thinking to
an agent. Every session should leave me sharper than before.

This means:

- I review every diff before it lands.
- I ask agents to explain tradeoffs, not just produce output.
- I push back on "clever" code that I cannot read and defend.
- I use planning and journalling to reinforce my own understanding.
- I treat agents as peer programmers, not as implementation machines.

## Design Values

Great design is not decoration — it is clarity made visible.

### Clean and Structured

I love designs that look great because they are well structured.
Thoughtful spacing, consistent alignment, intentional whitespace, a
restrained palette. Every element should feel placed, not dumped.

### Creative but Clear

Creativity should serve understanding, not fight it. I prefer bold
ideas that simplify rather than complicate. If a user has to think
about how to use it, the design failed — even if it looks beautiful.

### Inspiration

The design language I respond to:

- **Apple** — restraint, typographic care, physicality without clutter.
- **Google / Material** — systematic, scalable, color-driven structure.
- **OpenAI** — minimal, confident, letting the product speak.
- **Spotify** — dark, immersive, editorial without being heavy.
- **Stripe / Linear** — functional beauty, every pixel justified.

### Architecture as Design

Clean software architecture is design too. Module boundaries, API
shapes, naming, data flow — all of it should look as intentional as
a well-crafted UI. If the internal structure is ugly, the user
experience will eventually reflect it.
