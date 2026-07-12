---
name: "goal-decomposition"
description: "Break down vague goals into concrete, verifiable steps — dependency ordering, milestone definition, exit criteria, thin vertical slices, and actionable execution plans."
---

# Goal Decomposition

> Break down vague goals into concrete, verifiable steps — dependency ordering, milestone definition, exit criteria, thin vertical slices, and actionable execution plans.

## When to use

Use this skill whenever you receive a high-level, ambiguous, or multi-part goal. Before writing any code or producing any output, decompose the goal into sequenced, checkable deliverables with clear completion criteria.

## Core principle

**A goal is not actionable until it's decomposed.** Every hour spent clarifying and structuring a goal saves 3–5 hours of rework. Decomposition surfaces hidden assumptions, identifies dependencies, and creates a shared definition of success.

## The decomposition process

### Step 1: Clarify the goal

Ask yourself (or the requester) these questions before decomposing:

- What is the actual outcome desired? (Not the implementation, the result.)
- Who is the user or beneficiary of this outcome?
- What counts as success? How will we know it's done?
- Are there constraints (time, tech, budget, compatibility)?
- What existing systems or workflows does this touch?
- What is the simplest version that would deliver value?

**Output:** A one-paragraph restatement of the goal in concrete terms.

### Step 2: Identify deliverables

List the concrete things that must exist for the goal to be met:

- Code changes (new files, modifications, deletions)
- Documentation (README, API docs, migration guides)
- Configuration (env vars, CI/CD changes, feature flags)
- Tests (unit, integration, E2E, manual verification)
- Data (migrations, seed data, exports)

**Output:** A bullet list of tangible artifacts.

### Step 3: Order by dependency

Arrange deliverables so each step builds on the previous:

1. **Foundations** — things nothing else depends on (schema, config, types)
2. **Core logic** — the main behavior or algorithm
3. **Integration** — wiring core logic to the rest of the system
4. **Presentation** — UI, API endpoints, output formatting
5. **Verification** — tests, manual checks, monitoring
6. **Polish** — error messages, edge cases, docs, cleanup

**Rule:** If step B needs step A to work, A comes first — even if B is more visible or exciting.

### Step 4: Define milestones

Group deliverables into 3–5 milestones, each producing something demonstrable:

| Milestone | Contents | Demo-able? |
|-----------|----------|-----------|
| M1: Thin vertical slice | The smallest end-to-end version | ✅ Yes |
| M2: Core complete | All major functionality works | ✅ Yes |
| M3: Hardened | Error handling, edge cases, perf | ✅ Yes |
| M4: Ship-ready | Docs, tests, deployment | ✅ Yes |

**Each milestone must have exit criteria** — specific, checkable conditions that must be true before moving to the next milestone.

### Step 5: Identify risks

For each milestone, note:

- **Known unknowns:** Things you know you don't know yet
- **Technical risks:** Complex algorithms, unfamiliar APIs, performance concerns
- **Dependency risks:** Waiting on other teams, third-party services, data availability
- **Integration risks:** How this interacts with existing systems

**Mitigation:** For each risk, note the smallest next step that reduces it (a spike, a prototype, a conversation).

### Step 6: Write the plan

Output a structured plan:

```markdown
## Goal: [restated goal]

### Milestone 1: [name]
- [ ] Deliverable A — [exit criterion]
- [ ] Deliverable B — [exit criterion]
- Risk: [risk] → [mitigation]

### Milestone 2: [name]
- [ ] Deliverable C — [exit criterion]
...
```

## Decomposition patterns

### Pattern: Thin vertical slice

Identify the smallest possible path through the entire system that delivers value:

```
Goal: "Add a search feature"
Bad decomposition:
  1. Design search index schema
  2. Build indexing pipeline
  3. Build search API
  4. Build search UI

Good decomposition (thin vertical slice):
  1. Add a simple text search endpoint that filters by one field
  2. Add basic search UI with one input and results list
  3. Add indexing for additional fields
  4. Add pagination, facets, sorting
```

### Pattern: Dependency-first

When two deliverables could be done in parallel, pick the one that unblocks more downstream work:

```
Goal: "Build a checkout page"
  - Payment form (needs: price calculation → needs: cart total)
  - Cart summary (needs: cart data)
  → Cart data first, then cart total, then price calc, then payment form
```

### Pattern: Spike then implement

For high-uncertainty tasks, add a research milestone before implementation:

```
Goal: "Migrate database from MySQL to PostgreSQL"
  M0 (Spike): Test migration with a copy of production data
    - Measure downtime for full dump/restore
    - Check data type compatibility issues
    - Decide strategy: dump/restore vs sync tool
  M1 (Implement): Execute chosen strategy
```

## Decomposition anti-patterns

- **The flat list:** Listing 15 unordered tasks with no grouping makes dependencies invisible. Always group and order.
- **The implementation dive:** Decomposing into implementation details ("create a new class called X") rather than outcomes ("user can filter by date range"). Start with outcomes.
- **The wishful dependency:** Assuming something works without verifying it. "Add auth middleware" assumes the auth system exists. Verify foundations first.
- **The giant milestone:** Any milestone that takes more than a day or two of focused work is too large. Split it.
- **The hidden assumption:** "Just use the existing API" — have you checked the API actually supports what you need? A quick spike is cheaper than finding out mid-implementation.

## Decomposition outputs

For a given goal, produce:

1. **Restated goal** (1 paragraph)
2. **Deliverable list** (bullet items)
3. **Ordered milestone plan** with checkboxes and exit criteria
4. **Risk register** (risks + mitigations per milestone)

## Reference

- Goal decomposition is a form of Structured Planning used in engineering management
- Related to Work Breakdown Structure (WBS) in project management
- Thin vertical slice concept comes from Continuous Delivery and MVP thinking
