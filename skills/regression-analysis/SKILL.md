---
name: "Regression Analysis"
description: "Find regressions after changes — trace impact, identify risk areas, recommend defensive tests."
---

# Regression Analysis

> Find regressions after changes — trace impact, identify risk areas, recommend defensive tests.

## When to use

Use this skill when you've made a change and want to know what else it could break before shipping, or when you need a thorough risk assessment of a diff.

## How to analyze

1. Examine the full diff carefully
2. Check for: changed error handling, modified defaults, removed exports, shifted timing, altered validation
3. Trace shared utilities and types that consumers depend on
4. Consider both direct and transitive consumers
5. Look for behavioral changes in edge cases

## What to check

### Changed behavior
- Error handling changes
- Modified default values
- Removed exports
- Shifted timing or async behavior
- Altered validation logic
- Loosened or tightened types

### Edge cases
- Empty arrays, null values
- Boundary conditions
- Error states
- Race conditions

### Test coverage
- Do existing tests cover the changed behavior?
- Are tests adequate?
- What's missing?

## Output structure

### Summary
What changed, risk areas identified, overall risk level.

### Diff Overview
High-level summary of what the change does.

### Regression Risks
Each risk with:
- Affected consumer or module
- Nature of the risk
- Severity (high/medium/low)
- Whether existing tests cover it

### Recommended Defensive Tests
Specific test suggestions that would catch each regression risk.

## Principles
- Focus only on regression risk, not code quality
- Don't assume passing tests mean no regressions
- Don't ignore config, env, or build script changes
- Trace at least two levels deep for shared code
- Don't flag purely additive changes as risks
