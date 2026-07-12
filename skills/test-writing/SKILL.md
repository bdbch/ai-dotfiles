---
name: "test-writing"
description: "Write unit, integration, and E2E tests — follow project patterns, cover edge cases, stay deterministic."
---

# Test Writing

> Write unit, integration, and E2E tests — follow project patterns, cover edge cases, stay deterministic.

## When to use

Use this skill when you need tests written for new or existing code, want to improve test coverage, or need to fix flaky tests.

## Core principles

- Follow the testing pyramid: many unit, fewer integration, few e2e
- Prioritize by risk: critical paths, error-prone areas, shared utilities
- Test behavior, not implementation details
- Each test should have one clear reason to fail
- Name tests clearly: `should <expected behavior> when <condition>`
- Cover edge cases: boundary conditions, error states, empty/null inputs
- Write deterministic tests — no timing dependencies, no shared mutable state
- Prefer real implementations over mocks where practical

## What to test

### Unit tests
- Pure logic, utilities, hooks, helper functions
- Focus on inputs → outputs
- Mock only external dependencies

### Integration tests
- Component interactions, API calls, state flows
- Test multiple units working together
- Use real implementations where possible

### E2E tests
- Critical user paths only
- Test from the user's perspective
- Use real browser/device when possible

## Test setup patterns

### General setup
```ts
describe('feature: myComponent', () => {
  let wrapper: ReturnType<typeof mount>

  beforeEach(() => {
    wrapper = mountComponent()
  })
})
```

### Naming conventions
- `describe` = feature or component name
- `it` / `test` = behavior description starting with "should"
- Group related tests in nested `describe` blocks

## What to avoid

- Brittle tests that depend on implementation details
- Snapshot tests for large or frequently changing components
- Testing third-party library behavior
- Skipped or commented-out tests
- Flaky tests with timing dependencies
- 100% coverage as a goal — focus on high-risk areas
