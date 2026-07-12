---
name: "scope-management"
description: "Stay focused on the goal — MVP definition, scope creep detection, the parking lot pattern, tradeoff communication, and knowing when good enough is enough."
---

# Scope Management

> Stay focused on the goal — MVP definition, scope creep detection, the parking lot pattern, tradeoff communication, and knowing when good enough is enough.

## When to use

Use this skill throughout any project or task. Before starting, define what's in and out of scope. During execution, watch for scope creep. When new ideas arise, use the parking lot. When tradeoffs must be made, communicate them clearly.

## Core principle

**Scope is a contract.** When scope expands without adjusting time or resources, quality suffers. Managing scope means actively protecting the goal, not just adding features.

## Defining MVP scope

Before starting any work, establish:

```
## Scope

### In scope (what we ARE doing)
- [core functionality required for the goal]
- [must-have features]
- [critical quality requirements]

### Out of scope (what we are NOT doing)
- [nice-to-haves explicitly deferred]
- [related but separate features]
- [future iterations]

### Constraints
- Time: [deadline or time budget]
- Quality: [what quality level is acceptable]
- Compatibility: [what must continue to work]
```

### The MVP question

For every potential feature, ask:

> "What is the smallest thing we can deliver that still achieves the goal?"

If a feature isn't required for the goal to be met, it's out of scope for now.

## Detecting scope creep

Scope creep doesn't announce itself. Watch for these signals:

| Signal | What it sounds like | Action |
|--------|-------------------|--------|
| "While we're at it" | "While we're changing X, let's also Y" | Park it |
| "It's just a small thing" | "Adding Z would only take a minute" | Park it (small things add up) |
| "We should also" | Mid-implementation new requirement | Park it |
| "Let me make it perfect" | Polishing beyond the requirements | Stop — check the DoD |
| "This would be better if" | Gold-plating | Park it |
| Feature creep from feedback | New requests from stakeholders | Log for future, don't implement now |

### The parking lot pattern

When a new idea or feature comes up mid-work:

```markdown
## Parking Lot (captured for future, not implemented now)

| Idea | Why not now | When to revisit |
|------|-------------|----------------|
| Dark mode support | Not in current scope | After MVP ships |
| Export to PDF | User asked but not required | Next iteration |
| Analytics dashboard | Would take 2+ days | When we have 2+ days |
```

**Rule:** Once an idea goes in the parking lot, stop thinking about it. The parking lot is a commitment to revisit, not a commitment to implement.

## Making scope tradeoffs

When scope conflicts with time or quality:

```
### Problem: [feature X] will take longer than the deadline allows

Options:
  A. Cut [feature X], ship rest on time
     → Impact: users can't do X in v1, but everything else works
  B. Ship [feature X] partially (basic version)
     → Impact: X works for most cases, edge cases deferred
  C. Delay deadline by [time]
     → Impact: ship later but with full X

Recommendation: [A/B/C] because [rationale]
```

### Tradeoff communication template

```
## Tradeoff: Speed vs Completeness

We can deliver [core goal] by [date] if we:
  - Include: [list of in-scope features]
  - Defer: [list of deferred features]
  - Accept: [known limitations]

If we need [deferred feature], it adds [time/cost].
Decision needed: Is the deferred feature worth the delay?
```

## The scope contract

For every milestone or delivery, produce a scope contract:

```markdown
## Scope for: [deliverable name]

### Delivering
- [ ] [thing 1]
- [ ] [thing 2]

### Not delivering (yet)
- [thing 3] — captured in parking lot
- [thing 4] — future iteration

### Acceptable quality
- Works for [80%] of common cases
- [Known edge case] returns a clear error message
- Performance: [specific metric] under [specific load]

### Known risks
- [Risk 1] — mitigating by [action]
- [Risk 2] — accepting for now
```

## Scope anti-patterns

- **The ever-growing checklist:** Starting with 5 items, ending with 15. Freeze scope when work starts.
- **"It's just one more line":** One line becomes one function becomes one feature. Individual additions are easy to justify; their sum destroys the schedule.
- **The hidden expansion:** Adding scope without telling anyone. If you're working with someone, communicate scope changes.
- **The "while I'm here" trap:** Fixing unrelated bugs or adding unrelated features because you're "already in the code." Only fix things related to the goal.
- **The perfection spiral:** Making something perfect that doesn't need to be perfect. Match polish to the goal, not your personal standards.
- **The silent assumption:** Assuming a feature is in scope without checking. If you're unsure, ask.

## When to expand scope (legitimately)

Scope management isn't about never expanding — it's about expanding deliberately:

| Legitimate reason | How to handle |
|------------------|---------------|
| Discovered a blocker that needs fixing | Add it, note the impact on timeline |
| Security vulnerability in related code | Fix it, it's never optional |
| The requirement was wrong | Correct the requirement, adjust scope |
| Customer feedback changes priorities | Explicitly trade one feature for another |
| A simple change dramatically increases value | Assess the cost/benefit, decide consciously |

In every case, acknowledge the expansion and its impact. Don't absorb it silently.

## Combining with other skills

- **Goal Decomposition:** Defines what the goal is — Scope Management protects it
- **Definition of Done:** Provides the completion criteria for "enough"
- **Iterative Refinement:** Each cycle can re-evaluate scope
- **Error Recovery:** Prevents error-fixing from expanding into unrelated areas

## Reference

- MVP (Minimum Viable Product) — Eric Ries, The Lean Startup
- The Iron Triangle: scope, time, quality — you can't fix all three
- Parkinson's Law: work expands to fill the time available — scope does too
- YAGNI (You Aren't Gonna Need It) — extreme programming principle
