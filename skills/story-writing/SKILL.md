---
name: "story-writing"
description: "Write effective user stories — INVEST criteria, acceptance criteria, Gherkin/BDD scenarios, story mapping, splitting strategies, and refinement."
---

# Story Writing

> Write effective user stories — INVEST criteria, acceptance criteria, Gherkin/BDD scenarios, story mapping, splitting strategies, and refinement.

## When to use

Use this skill when writing user stories, defining acceptance criteria, planning work in iterations, or breaking down features into actionable units.

## Core principles

- **Stories are promises of conversations, not detailed specifications** — the written story is a placeholder for ongoing discussion
- **Focus on value, not implementation** — describe *what* the user needs, not *how* to build it
- **Small stories ship faster** — a story that takes longer than a few days is too large
- **Well-defined acceptance criteria make stories testable** — without them, done is subjective

## User story format

### Standard template

```
As a [user role]
I want [goal/desire]
So that [benefit/value]
```

### Examples

```
As a customer
I want to filter products by price range
So that I can find items within my budget

As an admin
I want to see a list of pending orders
So that I can fulfill them in a timely manner

As a returning user
I want to log in with my email and password
So that I can access my saved preferences
```

## INVEST criteria

Every story should be:

| Letter | Criterion | What it means | Red flag |
|--------|-----------|---------------|----------|
| **I** | Independent | Can be developed and released independently | "This story depends on story X" |
| **N** | Negotiable | Details emerge through conversation | "The UI must be exactly this mockup" |
| **V** | Valuable | Delivers value to users or stakeholders | Doesn't benefit anyone directly |
| **E** | Estimable | Team can estimate effort | Too vague or too technical |
| **S** | Small | Fits within a single iteration | "Epic" level — needs splitting |
| **T** | Testable | Clear pass/fail criteria | "Should work well" |

## Acceptance criteria

### Rule-based format

```
Given [context/precondition]
When [action/trigger]
Then [expected outcome]
```

### Example

```
Scenario: Customer filters by price range
  Given there are products priced $5, $15, and $50
  When the customer sets the price filter to $10 - $30
  Then only the $15 product is shown
```

### Multiple rules

```
- [ ] Filtering by minimum price returns products with price >= min
- [ ] Filtering by maximum price returns products with price <= max
- [ ] Setting both min and max returns products in the range
- [ ] Setting min > max shows empty results (or defaults)
- [ ] Clearing filters restores the full product list
- [ ] Results update immediately without page reload
```

## Story splitting patterns

When a story is too large, split it using these patterns:

| Pattern | Description | Example |
|---------|-------------|---------|
| **Workflow step** | Split a multi-step process | "Login" → "Enter email" + "Enter password" + "2FA" |
| **Happy vs edge** | Handle happy path first, edge cases later | "Checkout" → "Simple checkout" + "Error handling" + "Retry logic" |
| **Data type** | Support one format first | "Import" → "CSV import" + "JSON import" + "Excel import" |
| **Operation** | CRUD split | "Manage products" → "Create product" + "View product" + "Edit product" + "Delete product" |
| **UI vs backend** | Backend first, UI later | "Search" → "Search API" + "Search UI component" |
| **Simple → complex** | Start with basic case | "Discount" → "Percentage discount" + "Fixed amount" + "Buy-one-get-one" |

## Story mapping

Organize stories along two dimensions:

```
           | v1 (MVP)      | v2             | v3
───────────┼───────────────┼────────────────┼──────────────
Browse     | List products | Search & filter | Category nav
Select     | Product page  | Image gallery   | 360° view
Purchase   | Add to cart   | Coupon codes    | Gift wrap
Pay        | Credit card   | PayPal          | BNPL
```

- **Horizontal:** Activities (steps a user takes)
- **Vertical:** Slices of value (versions/releases)

## Refinement checklist

Before a story is "ready" for development:

```
[ ] Format: As a [user] I want [goal] So that [benefit]
[ ] Size: Can be completed in <2 days
[ ] Acceptance criteria: Clear pass/fail scenarios
[ ] Dependencies: Known and resolved
[ ] Design: UX direction clarified (mockups if needed)
[ ] Technical notes: Architecture decisions documented
[ ] Estimation: Team has rough effort estimate
```

## Stories vs other work types

| Work type | When to use |
|-----------|-------------|
| **User story** | Delivers direct user value |
| **Technical story** | Enables future stories (refactoring, upgrades) |
| **Spike** | Investigate an unknown to reduce risk (timeboxed) |
| **Bug** | Something that used to work but doesn't |
| **Chore** | Maintenance tasks (CI, dependency updates) |

## Anti-patterns

- **The solution story**: "Add a button that calls the API"... says *how*, not *what*. Rewrite from the user's perspective.
- **The epic that never splits**: A story that's 2+ weeks of work. Split it.
- **The checklist story**: "Implement the settings page" with 30 acceptance criteria. That's 10 stories, not one.
- **The vague criteria**: "Should work well", "Fast enough". Make it measurable.
- **The design-by-story**: Using stories to document every UI detail in advance. Stories are for conversation; mockups are for design details.

## Reference

- [User Stories Applied](https://www.mountaingoatsoftware.com/books/user-stories-applied) — Mike Cohn
- INVEST criteria — Bill Wake
- Gherkin language (Given/When/Then) — Cucumber/BDD
- [Story Mapping](https://jpattonassociates.com/user-story-mapping/) — Jeff Patton
