---
name: "iterative-refinement"
description: "Progressive improvement through disciplined cycles — Draft → Review → Revise → Finalize, stop criteria, feedback integration, and quality progression."
---

# Iterative Refinement

> Progressive improvement through disciplined cycles — Draft → Review → Revise → Finalize, stop criteria, feedback integration, and quality progression.

## When to use

Use this skill when producing any significant output — code, design, documentation, architecture. Rather than trying to get everything perfect in one pass, use iterative cycles to progressively improve quality.

## Core principle

**Make it work, make it right, make it fast.** Attempting all three at once produces none of them. Each iteration has a clear focus, and each has a stop criterion that says "good enough, move on."

## The refinement cycle

```
┌─────────────────────────────────────────┐
│           1. DRAFT                       │
│   Focus: Make it exist                   │
│   "Rough but working"                    │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│           2. REVIEW                      │
│   Focus: Make it correct                 │
│   Check against requirements             │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│           3. REVISE                      │
│   Focus: Incorporate feedback            │
│   Fix gaps, refine approach              │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│           4. FINALIZE                    │
│   Focus: Polish and ship                │
│   "Good enough, ship it"                │
└─────────────────────────────────────────┘
```

Each cycle tightens: Draft is rough, Review is critical, Revise is targeted, Finalize is minimal.

## When to stop: diminishing returns detection

The most important judgment in refinement is knowing when to stop. Use these cues:

| Signal | What it means |
|--------|---------------|
| Changes are getting smaller | Approaching good enough |
| Each round fixes fewer issues | Diminishing returns |
| You're rearranging rather than improving | Bike-shedding — stop |
| You're adding "perfect" features no one asked for | Gold-plating — stop |
| You can't articulate what the next pass would improve | You're done |

**Rule of thumb:** After 2–3 refinement cycles on the same artifact, ship it unless there's a specific, documented issue remaining.

## Draft stage (first pass)

**Goal:** Make it exist. Not perfect. Not beautiful. Working.

```
Draft checklist:
  [ ] Core behavior works (happy path)
  [ ] Main structure is in place
  [ ] Naming and organization are reasonable
  [ ] It's complete enough to review

Draft is NOT the time for:
  - Perfect error handling
  - Every edge case
  - Performance optimization
  - Elegant abstractions
  - Documentation polish
```

**Draft exit criterion:** A reviewer (human or automated) can understand the intent and give meaningful feedback on the approach.

## Review stage (second pass)

**Goal:** Make it correct against the requirements.

```
Review against:
  [ ] Acceptance criteria (Definition of Done)
  [ ] Edge cases: empty, error, loading, max
  [ ] Error handling
  [ ] Existing behavior (regressions)
  [ ] Code quality: naming, comments, complexity
  [ ] Tests: do they test the right things?
```

**Review methods:**

- **Self-review:** Read through your own output as if you were someone else
- **Automated review:** Lint, type check, test suite, security scan
- **Peer review:** Ask another person (or agent) to review

**Review exit criterion:** All acceptance criteria are met and no blocking issues remain.

## Revise stage (third pass)

**Goal:** Incorporate feedback and close gaps.

```
Revise checklist:
  [ ] Address all blocking review feedback
  [ ] Fix identified bugs or gaps
  [ ] Improve unclear areas
  [ ] Re-verify after changes
```

**Key rule:** One change per reason. If you're fixing multiple things, do them as separate, atomic revisions so each is independently verifiable.

**Revise exit criterion:** All identified issues are resolved. No new issues introduced.

## Finalize stage (shipping)

**Goal:** Polish and ship. This is the smallest, most focused cycle.

```
Finalize checklist:
  [ ] Remove debug artifacts (console.log, TODOs, commented code)
  [ ] Final review of diffs/changes
  [ ] Verify CI/smoke tests pass
  [ ] Update changelog/docs if needed
  [ ] Ship / push / PR
```

**Finalize exit criterion:** Shipped. Done. Move to the next task.

## Real-world example

```markdown
## Task: Add search to the product API

### Draft (1st pass)
- Created basic `/api/products/search?q=` endpoint
- Filters by name field using SQL LIKE
- Returns matching products
- No pagination, no error handling
→ Draft done: works for basic case, reviewable structure

### Review
- Missing: search should also match description
- Missing: SQL injection risk with raw LIKE
- Missing: empty query returns 500
- Missing: no limit on results
→ 4 issues found

### Revise
- Added description field to search
- Switched to parameterized query
- Added empty query validation (returns empty array)
- Added limit=20 default
→ All 4 issues fixed

### Finalize
- Removed debug logging
- Ran full test suite (all pass)
- Wrote changelog entry
- Pushed PR
→ Shipped
```

## Refinement anti-patterns

- **The infinite polish loop:** "Let me just tweak one more thing..." Set a hard limit on refinement cycles.
- **The big bang rewrite:** Rewriting everything in one go instead of iterating. Always start with a draft.
- **Skipping review:** "It's small, I don't need to review it." Every change benefits from a second look.
- **Perfectionism on the draft:** Trying to make the first pass perfect defeats the purpose of iteration.
- **The perfectionist reviewer:** Demanding the revision address things that aren't in the requirements.

## Combining with other skills

- **Verification-First:** Each iteration ends with verification
- **Definition of Done:** Provides the criteria for "good enough"
- **Goal Decomposition:** Each milestone can go through its own refinement cycles
- **Error Recovery:** When a refinement introduces bugs, use error recovery

## Reference

- "Make it work, make it right, make it fast" — Kent Beck
- The iterative model is fundamental to Agile and Extreme Programming
- Continuous improvement (Kaizen) applies iteration to processes, not just code
