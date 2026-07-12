---
name: "verification-first"
description: "Write verification methods before implementation — self-checking workflows, the Verify → Implement → Confirm cycle, regression guardrails, and manual verification strategies."
---

# Verification First

> Write verification methods before implementation — self-checking workflows, the Verify → Implement → Confirm cycle, regression guardrails, and manual verification strategies.

## When to use

Use this skill before and during any implementation task. Before writing code, decide how you'll verify it works. After writing code, confirm against that verification before moving on.

## Core principle

**How will I know when this works?** If you can't answer that question before you start, you'll never be certain when you're done. Verification-first means you always have a test before you have a fix.

## The Verify → Implement → Confirm cycle

```
┌─────────────────┐
│  1. VERIFY      │  ← Decide how to check success
│  "I'll know it  │
│   works when…"  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  2. IMPLEMENT   │  ← Write the code/change
│  (smallest step  │
│   possible)     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  3. CONFIRM     │  ← Run the verification
│  Pass? → Next   │
│  Fail? → Fix    │
└─────────────────┘
```

**Key rule:** Never go to Implement without a verification plan. Never leave Confirm without either a pass or a clear understanding of what failed.

## Types of verification

### Automated checks

These are fast, repeatable, and objective:

| Method | When to use | Example |
|--------|-------------|---------|
| Unit test | Isolated function/module behavior | `assert sum(2, 2) == 4` |
| Type check | Type safety | `npx tsc --noEmit` |
| Lint | Code style/conventions | `npx eslint` |
| Integration test | Component interaction | Request → response cycle |
| Snapshot test | UI/output stability | `toMatchSnapshot()` |
| Compile | Syntax/structural validity | `cargo build`, `tsc`, `go build` |
| CI pipeline | Full suite | `npm test` in CI |

### Manual verification

When automation isn't practical (UI behavior, design review, complex state), define a manual check:

```
Manual check: Registration form
  1. Navigate to /register
  2. Submit without filling fields → see validation errors
  3. Enter invalid email → see inline error
  4. Enter valid data → see confirmation screen
  5. Check that user record exists in database
```

### Visual verification

For UI changes, define what to look at:

```
Visual check: Button styling PR
  - Button has correct padding, color, font
  - Hover state is slightly darker
  - Active state has inset shadow
  - Disabled state is grayed out, no hover effect
  - Works in light and dark mode
  - No layout shift when button text changes
```

### Regression guard

Before changing existing behavior, verify the old behavior still works:

```
Before changing the pricing logic:
  [✅] Existing test suite passes (regression baseline)
  [✅] Manual check: current prices display correctly
  [  ] New pricing logic produces correct values
  [  ] Old edge cases still handled (free tier, max tier)
```

## Verification-first in practice

### Before starting a task

```markdown
## Verification plan for: [task name]

### Success checks
1. [ ] [automated check] — e.g., "Unit test for calculateTotal passes"
2. [ ] [manual check] — e.g., "Form submits with valid data"
3. [ ] [regression check] — e.g., "Existing search still works"

### Failure scenarios to test
1. [ ] [what happens when input is empty]
2. [ ] [what happens when service is down]
3. [ ] [what happens with max allowed input]
```

### After implementing

Run each check. Document results:

```markdown
## Verification results

1. ✅ Unit test for calculateTotal passes
2. ✅ Form submits with valid data
3. ✅ Existing search still works
—— All checks passed, proceeding to next task ——
```

## When verification fails

| Symptom | Likely cause | Action |
|---------|-------------|--------|
| Test fails | Implementation incorrect | Debug and fix |
| Test passes but behavior is wrong | Test is wrong | Fix the test |
| Manual check fails | Edge case not handled | Add handling |
| Regression test fails | Side effect of change | Revisit approach |
| Can't verify | No clear success criteria | Go back to Definition of Done |

## Verification anti-patterns

- **"I'll just test it manually"** without defining steps → vague and unrepeatable. Always write the steps down.
- **"The tests pass so it's done"** without checking the test quality → tests might not test the right thing.
- **"I'll verify at the end"** → discovering failures late costs 5x more to fix. Verify incrementally.
- **"It looks right"** without checking edge cases → most bugs live in edge cases.
- **"I'll add tests later"** → "later" rarely comes. Write the verification plan before implementation.

## Combining with other skills

- **Definition of Done** provides the criteria; Verification-First provides the method to check them
- **Goal Decomposition** creates milestones; Verification-First confirms each milestone
- **Iterative Refinement** uses verification to decide when to stop refining

## Reference

- Test-Driven Development (TDD): Red → Green → Refactor maps to Verify → Implement → Confirm
- Continuous Integration: verify every change automatically
- Shift-left testing: verify as early as possible in the development process
