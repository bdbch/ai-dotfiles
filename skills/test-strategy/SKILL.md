---
name: "Test Strategy"
description: "Plan test strategy — what to test, at what level, coverage targets, and edge cases."
---

# Test Strategy

> Plan test strategy — what to test, at what level, coverage targets, and edge cases.

## When to use

Use this skill when you need a test plan for a feature, refactor, or entire project — or when identifying testing gaps.

## How to plan

1. Read the code changes or feature requirements
2. Understand existing test patterns in the project
3. Identify what needs testing and at what level
4. Prioritize by risk

## Output structure

### Summary
What is being tested, at what levels, overall coverage goal.

### Test Scope
What is in scope, what is out, and why.

### Test Plan

#### Unit tests
Pure logic, utilities, hooks. Specify what to assert and edge cases.

#### Integration tests
Component interactions, API calls, state flows. Specify scenarios and expected behavior.

#### E2E tests
Critical user paths. Specify user flow and success criteria.

### Edge Cases to Cover
Boundary conditions, error states, empty/null inputs, race conditions.

### What Not to Test
Trivial code, generated code, third-party wrappers, obvious one-liners.

## Principles
- Follow testing pyramid: many unit, fewer integration, few e2e
- Prioritize by risk: critical paths, error-prone areas, shared utilities
- Choose lowest test level that meaningfully verifies behavior
- Consider flakiness — prefer deterministic tests
- Weigh maintenance cost against value
- Flag areas where coverage is misleading
