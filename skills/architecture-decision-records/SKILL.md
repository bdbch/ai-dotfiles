---
name: "architecture-decision-records"
description: "Write and manage Architecture Decision Records — ADR format, status lifecycle, tradeoff analysis, templates, and integration with project workflow."
---

# Architecture Decision Records

> Write and manage Architecture Decision Records — ADR format, status lifecycle, tradeoff analysis, templates, and integration with project workflow.

## When to use

Use this skill when making non-trivial architecture or design decisions — choosing between technologies, designing system structure, adopting patterns, or changing existing approaches. ADRs capture the context, options, and rationale so future contributors understand *why* a decision was made.

## Core principle

**The most important part of a decision is not what was chosen, but why.** ADRs document the context, alternatives considered, and rationale so that:
- New team members understand past decisions
- Future changes can evaluate whether the context has changed
- Decisions are made deliberately, not by accident

## ADR format (Michael Nygard)

### Template

```markdown
# ADR-[number]: [Title]

## Status

[Proposed | Accepted | Deprecated | Superseded]

## Context

[What is the issue motivating this decision? What forces are at play?
Include relevant background, constraints, and assumptions.]

## Decision

[What was decided? Use active voice: "We will..." rather than passive.]

## Consequences

[What are the tradeoffs? What becomes easier, harder, or different?
Include both benefits and costs.]

## Options considered

### Option A: [name]

- **Pros:** [list of advantages]
- **Cons:** [list of disadvantages]

### Option B: [name]

- **Pros:** [list of advantages]
- **Cons:** [list of disadvantages]

## Rationale

[Why was the chosen option selected over the alternatives?]
```

### Example

```markdown
# ADR-7: Use PostgreSQL over MongoDB for the product catalog

## Status

Accepted

## Context

We need a database for the product catalog service. The catalog
has complex relationships (products, categories, variants, attributes)
with evolving schema requirements. We expect heavy read traffic
with moderate writes.

Initial team discussion explored both relational and document options.

## Decision

We will use PostgreSQL for the product catalog.

## Consequences

Positive:
- Strong schema enforcement catches data inconsistencies early
- Native JSONB support handles flexible product attributes
- Mature migration tooling (e.g., Flyway, pgroll)
- ACID transactions make inventory management reliable

Negative:
- Schema changes require migrations (more process than MongoDB)
- JOIN-heavy queries may need optimization at scale
- Team needs PostgreSQL expertise (one member has MongoDB background)

## Options considered

### Option A: PostgreSQL (chosen)
- **Pros:** Strong consistency, JSONB for flexible attributes,
  excellent tooling, team mostly familiar
- **Cons:** Schema changes need migrations, slightly higher
  operational overhead for replication

### Option B: MongoDB
- **Pros:** Schema-less fits evolving product attributes,
  horizontal scaling built-in
- **Cons:** No built-in JOINs (app-level joins needed),
  weaker consistency guarantees, no team experience

## Rationale

PostgreSQL's JSONB column gives us the schema flexibility
we need, while maintaining relational integrity for the
structured parts of the catalog. The team's existing
PostgreSQL knowledge and mature migration tooling outweigh
MongoDB's scaling advantages for our expected volume.
```

## Status lifecycle

```
         ┌──────────┐
         │ Proposed │
         └────┬─────┘
              │
              ▼
         ┌──────────┐
         │ Accepted │ ◄── Active decision (most ADRs live here)
         └────┬─────┘
              │
    ┌─────────┴──────────┐
    ▼                    ▼
┌────────────┐   ┌──────────────┐
│ Superseded │   │  Deprecated  │
│ (by ADR-N) │   │ (no longer   │
└────────────┘   │  recommended)│
                 └──────────────┘
```

- **Proposed:** Draft, under discussion
- **Accepted:** Approved and active
- **Deprecated:** Still in use but no longer recommended
- **Superseded:** Replaced by a newer ADR (link to it)

## When to write an ADR

| Write an ADR | Don't write an ADR |
|-------------|-------------------|
| Choosing a technology or library | Which CSS framework to use (unless it's a major architectural decision) |
| Designing system structure (monolith vs microservices, sync vs async) | A specific API endpoint design |
| Changing a previous decision | Day-to-day implementation details |
| Introducing a new pattern or convention | Bug fixes |
| Significant infrastructure decisions | Minor refactoring |
| External integration strategy | Code formatting conventions |

## Template tools

Store ADRs in the repository:

```
docs/adr/
├── README.md            # Index with status table
├── 001-use-postgres.md
├── 002-frontend-framework.md
├── 003-api-design.md
└── index.md             # Auto-generated or manually maintained
```

### Index table

```markdown
# Architecture Decision Records

| # | Title | Status | Date |
|---|-------|--------|------|
| 7 | Use PostgreSQL over MongoDB | Accepted | 2024-01-15 |
| 6 | Adopt event-driven messaging | Superseded by ADR-8 | 2023-11-20 |
| 5 | TypeScript for frontend | Accepted | 2023-10-01 |
```

## ADR vs other documents

| Document | Scope | When to use |
|----------|-------|-------------|
| **ADR** | Single decision | Choosing between options |
| **RFC** | Feature/systems design | Designing a new system with multiple decisions |
| **Design doc** | Full architecture | Before starting a major project |
| **Wiki page** | Ongoing reference | Documenting how something works (not decisions) |

## Reviewing ADRs

An ADR should be reviewed before acceptance:

```markdown
Review criteria:
  [ ] Context is complete enough to understand the decision
  [ ] Multiple alternatives were considered
  [ ] Chosen option is clearly justified
  [ ] Consequences are honestly assessed
  [ ] Tradeoffs are acknowledged (no perfect option)
  [ ] Links to relevant resources, spikes, or research
```

## ADR anti-patterns

- **Writing the decision but not the context:** Readers don't know *why* it was chosen
- **Only listing one option:** If only one option was considered, more research is needed
- **Hiding tradeoffs:** No option is perfect. Acknowledging negatives builds trust
- **Never revisiting:** Accepted decisions should be revisited when context changes
- **Too many trivial ADRs:** Not everything needs an ADR. Use judgment
- **Too few ADRs:**
- **Removing superseded ADRs:** Old decisions should stay in the log, marked as superseded, so history is preserved

## Reference

- [Michael Nygard's ADR blog post](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
- [ADR GitHub organization](https://adr.github.io/) — tooling and resources
- [MADR (Markdown ADR)](https://adr.github.io/madr/) — lightweight template
- [Log4brains](https://github.com/thomvaill/log4brains) — ADR management tool
