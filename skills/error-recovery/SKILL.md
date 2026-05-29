---
name: "Error Recovery"
description: "Systematically recover from failures — isolate, diagnose, fix, verify, prevent. The three-attempts rule, evidence gathering before guessing, and when to roll back vs push forward."
---

# Error Recovery

> Systematically recover from failures — isolate, diagnose, fix, verify, prevent. The three-attempts rule, evidence gathering before guessing, and when to roll back vs push forward.

## When to use

Use this skill when something goes wrong: a test fails, code doesn't compile, the UI doesn't render, an API returns an error, or a deployment breaks. This provides a structured recovery procedure instead of guessing and repeating.

## Core principle

**Errors are data, not failures.** Every error message, stack trace, and unexpected behavior contains information about what's wrong. The goal is to extract that information systematically, apply the smallest effective fix, and confirm it worked — then prevent it from happening again.

## The recovery protocol

```
┌─────────────────────────────────────┐
│  1. ISOLATE                         │
│  "What is the smallest reproduction?"│
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│  2. DIAGNOSE                        │
│  "What does the evidence say?"       │
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│  3. FIX                             │
│  "What is the smallest change?"      │
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│  4. VERIFY                          │
│  "Did it work without side effects?" │
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│  5. PREVENT                         │
│  "How do we stop this recurring?"    │
└─────────────────────────────────────┘
```

## Step 1: Isolate

**Goal:** Narrow the problem to the smallest possible reproduction.

```
Questions to ask:
  - Does this happen consistently or intermittently?
  - Does it happen in isolation (minimal example)?
  - Does it happen with different inputs?
  - Did it work before? If so, what changed?

Actions:
  - Create a minimal reproduction (strip away unrelated code)
  - Check if the issue reproduces in a clean environment
  - Check recent changes (git log, blame)
  - Check environment differences (local vs CI vs prod)
```

**Isolation exit criterion:** You can reproduce the error with a specific, minimal set of conditions.

## Step 2: Diagnose

**Goal:** Understand the root cause before attempting a fix.

```
Evidence to gather before any fix:
  - Exact error message and stack trace
  - Input that triggers the error
  - Expected vs actual output
  - State at the time of failure (logs, variables, database)
  - Recent changes that touch the failing area

Diagnostic techniques:
  - Read the stack trace from top to bottom (last frame is where it crashed)
  - Check logs at the time of failure
  - Add targeted logging (don't guess — add a log, run, observe)
  - Check documentation for the API/library being used
  - Compare with known working examples
```

**Key rule:** Before writing any fix, write down what you think is wrong in one sentence. If you can't, you haven't diagnosed enough.

## Step 3: Fix

**Goal:** Apply the smallest possible change that addresses the root cause.

```
Fix principles:
  - One change at a time (resist the urge to fix multiple things)
  - Change the code that's wrong, not the test/check that caught it
  - If the fix is complex, the diagnosis might be wrong
  - Prefer local fixes over global changes (don't refactor while fixing)

The "three attempts" rule:
  1st attempt: Direct fix based on diagnosis
  2nd attempt: Re-diagnose, different approach
  3rd attempt: Escalate — ask for help, change strategy entirely

After three failed attempts, stop and:
  - Re-examine your assumptions (is the diagnosis correct?)
  - Look for similar solved problems
  - Consider a different approach altogether
  - If working with someone, share what you've tried
```

## Step 4: Verify

**Goal:** Confirm the fix works AND nothing else broke.

```
Verify checklist:
  [ ] The original reproduction no longer errors
  [ ] The fix works for edge cases of the same issue
  [ ] Related tests still pass
  [ ] Adjacent functionality still works (no regression)
  [ ] The fix doesn't introduce new issues

If verification fails:
  - Undo the fix (git checkout -- file)
  - Go back to Diagnose (you missed something)
  - Don't pile fixes on top of fixes
```

## Step 5: Prevent

**Goal:** Stop this error from happening again — or catch it faster when it does.

```
Prevention strategies:
  - Add a test that covers this exact case
  - Add input validation if the error was caused by unexpected data
  - Add better error messages if the error was hard to diagnose
  - Add monitoring/alerting if it happened in production
  - Add documentation if the fix involved non-obvious logic
  - Consider if similar bugs exist in related code (pattern fix)
```

## When to roll back vs push forward

| Situation | Action |
|-----------|--------|
| Error in development, easy fix | Fix forward |
| Error in development, unclear cause | Roll back, investigate |
| Error in production, hotfix available | Fix forward with urgent review |
| Error in production, unclear cause | Roll back immediately |
| Fix introduces new error | Roll back, re-diagnose |
| Can't reproduce | Add logging, leave fix for when more info available |

**Roll back is never a failure.** It's the safest path when you don't fully understand the error or can't verify the fix.

## Common errors and quick checks

| Symptom | First things to check |
|---------|----------------------|
| Compile/build error | Read the FIRST error message (not the cascade that follows) |
| Test fails | Did the test exist before? Did the code change? Is the test wrong? |
| UI not rendering | Console errors, network requests, component props |
| API returns 500 | Server logs, request payload, database connectivity |
| Wrong data | Check the query, check the transformation, check the display |
| Slow performance | Profile first, guess second. Measure before optimizing |
| Regression | Check git log for recent changes to the affected area |

## Recovery anti-patterns

- **Guessing without evidence:** "Maybe it's X" → changing X without checking. Diagnose first.
- **The shotgun fix:** Changing five things at once hoping one works. One change at a time.
- **Ignoring the stack trace:** The stack trace tells you exactly where it crashed. Read it.
- **Fixing the symptom, not the cause:** Catching the error without fixing why it happened.
- **Never rolling back:** Trying to fix forward when a rollback + clean fix is faster and safer.
- **Repeating the same fix:** Trying the same approach three times expecting different results.
- **Skipping prevention:** Fixing without adding a test means it will come back.

## Combining with other skills

- **Verification-First:** Use verification to confirm the fix
- **Iterative Refinement:** Error recovery is refinement forced by a failure
- **Definition of Done:** Failed verification means done criteria aren't met yet
- **Scope Management:** Don't let error recovery pull you into unrelated areas

## Reference

- Root Cause Analysis (RCA) is the engineering practice of systematic diagnosis
- The Five Whys technique: ask "why" five times to get from symptom to root cause
- Blameless postmortems: focus on systemic issues, not individual mistakes
- Rubber duck debugging: explaining the problem to someone else (or an inanimate object) often reveals the solution
