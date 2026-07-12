---
name: "definition-of-done"
description: "Write clear completion criteria before starting work — acceptance criteria formats, quality gates, scope boundaries, and the done checklist pattern."
---

# Definition of Done

> Write clear completion criteria before starting work — acceptance criteria formats, quality gates, scope boundaries, and the done checklist pattern.

## When to use

Use this skill before starting any task or milestone. Establish "what does done look like?" upfront so you know when to stop, when to ship, and when you've succeeded.

## Core principle

**Done is not a feeling — it's a checklist.** Without explicit criteria, work either stretches indefinitely (gold-plating) or ships prematurely (unknown gaps). A Definition of Done (DoD) provides an objective, shared answer to "is this finished?"

## Writing acceptance criteria

### Rule-based format

Best for clear, binary requirements:

```
- [ ] The form validates email format before submitting
- [ ] Error messages appear inline below the relevant field
- [ ] Successful submission shows a confirmation message
- [ ] The page scrolls to the first error on validation failure
```

### Scenario-based format (Given/When/Then)

Best for behavioral requirements:

```
Scenario: User submits with invalid email
  Given the user is on the registration form
  When they enter "not-an-email" in the email field
    And click Submit
  Then they see "Please enter a valid email address"
    And the form is not submitted
```

### Checklist format

Best for process/review tasks:

```
Pre-work:
  [ ] Understood the existing code paths this touches
  [ ] Identified related tests that must still pass

Implementation:
  [ ] [specific behavior works]
  [ ] [specific behavior works]

Quality gates:
  [ ] Lint passes
  [ ] Existing tests pass
  [ ] New tests cover the change
  [ ] No visible console errors in browser

Post-work:
  [ ] Changes are pushed/PR'd
  [ ] PR description explains what and why
  [ ] Related issue is linked
  [ ] Affected documentation is updated
```

## Levels of "done"

| Level | Scope | Examples |
|-------|-------|----------|
| **Task-level** | Single change | A function, a component, a migration |
| **Feature-level** | User-visible capability | Search, checkout, export |
| **Milestone-level** | Group of features | Sprint, release, epic |
| **Release-level** | Ship to users | Version bump, changelog, deploy |

Each level inherits criteria from the level below. Feature-level done means all its task-level items are done plus integration tests pass.

## Quality gates (universal)

These apply to every code change regardless of scope:

| Gate | Check |
|------|-------|
| ✅ Compiles | No build errors, no type errors |
| ✅ Lints | No lint violations |
| ✅ Tests pass | New and existing tests green |
| ✅ No regressions | Verified that related behavior still works |
| ✅ No debug artifacts | No `console.log`, `dd()`, `TODO` commit |
| ✅ Error paths handled | What happens when it fails? |
| ✅ Edge cases | Empty state, loading state, error state, max values |

## Scope boundaries

A Definition of Done must also say what is **not** in scope:

```
In scope:
  - Basic CRUD for products
  - Search by name
  - Pagination (20 per page)

Out of scope:
  - Advanced search filters (future)
  - Bulk import/export (future)
  - Product variants (separate project)
```

This prevents scope creep and keeps the DoD objective.

## The done checklist pattern

Before any work begins, produce a checklist like this:

```markdown
## Definition of Done

### Acceptance criteria
- [ ] User can [action] with [conditions]
- [ ] System responds with [expected result]
- [ ] Error case: [specific failure is handled]

### Quality gates
- [ ] Build passes
- [ ] Tests added/updated
- [ ] Manual smoke test passes
- [ ] No regression in [adjacent feature]

### Delivery
- [ ] Changes committed
- [ ] PR description written
- [ ] Reviewer guidance included
```

## When done is NOT done

| False signal | Why it's not done |
|-------------|-------------------|
| "It compiles" | Compilation is table stakes, not completion |
| "Mostly works" | Edge cases and error paths are the long tail |
| "The happy path works" | Sad paths are where users live |
| "I just need to clean it up" | Cleanup is part of the work, not separate |
| "Tests pass locally" | CI matters; environments differ |
| "The code is written but not pushed" | Committed/pushed is the minimum for "done" |

## Pitfalls & gotchas

- **Don't write the DoD in isolation** — if you're working with someone, align on criteria before starting
- **Don't move the goalposts** — once work starts, criteria should not grow unless the scope formally changes
- **Don't skip edge cases** — error states, empty states, loading states, and max-value states are not "extra"
- **Don't confuse effort with progress** — 90% of the effort is often in the last 10% of the criteria
- **Don't forget non-functional criteria** — performance, accessibility, security, and maintainability are real requirements

## Reference

- Definition of Done is a core Scrum/Agile concept
- INVEST criteria for user stories (Independent, Negotiable, Valuable, Estimable, Small, Testable)
- Given/When/Then from Behavior-Driven Development (BDD)
