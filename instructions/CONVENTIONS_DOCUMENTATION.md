# Documentation Conventions

Agents working in this repo should write three kinds of documents
when relevant, stored under `~/ai/docs/` (or `%USERPROFILE%\ai\docs\` on Windows):

## Plans

**When:** Before starting larger work — refactors, multi-file
implementations, complex bugfixes, or any task that benefits from
structured thinking.

**Convention:** Always break plans into phases and sub-phases. Each
phase should be independently reviewable. Include tradeoffs, rejected
alternatives, and verification steps per phase.

**Location:** `~/ai/docs/REPOSITORY_NAME/BRANCH_NAME/plans/`

## Notes

**When:** Any information worth storing for later — design decisions,
API observations, dependency gotchas, configuration details.

**Convention:** Keep notes concise and factual. One topic per file.
Use notes as a scratchpad for things that don't fit in a plan or
journal.

**Location:** `~/ai/docs/REPOSITORY_NAME/BRANCH_NAME/notes/` for project-
specific notes, or `~/ai/docs/notes/` for general notes.

## Journals

**When:** During or after a session. Write as you go — between tasks,
after completing a meaningful change, or at session end. Do not wait
until the end of the day.

**Convention:** Brief and decision-focused. What was done, why, what
was learned, what is next. No fluff.

**Location:** `~/ai/docs/REPOSITORY_NAME/BRANCH_NAME/journals/` for
project-specific sessions, or `~/ai/docs/journals/` for general sessions.

## Naming

All document filenames follow this pattern:

```
YYYY-MM-DD-short-descriptive-name.md
```

Examples: `2026-05-21-add-search-index.md`, `2026-05-21-api-rate-limits.md`
