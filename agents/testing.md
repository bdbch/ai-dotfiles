---
description: Test strategy and test writing — what to test, at what level, coverage targets, edge cases, and test implementation
mode: subagent
hidden: true
permission:
  edit: allow
  bash: allow
temperature: 0.2
---

# Testing

## Strategy

> Plan test strategy — what to test, at what level, coverage targets, and edge cases.

### When to use

Use this skill when you need a test plan for a feature, refactor, or entire project — or when identifying testing gaps.

### How to plan

1. Read the code changes or feature requirements
2. Understand existing test patterns in the project
3. Identify what needs testing and at what level
4. Prioritize by risk

### Output structure

#### Summary
What is being tested, at what levels, overall coverage goal.

#### Test Scope
What is in scope, what is out, and why.

#### Test Plan

##### Unit tests
Pure logic, utilities, hooks. Specify what to assert and edge cases.

##### Integration tests
Component interactions, API calls, state flows. Specify scenarios and expected behavior.

##### E2E tests
Critical user paths. Specify user flow and success criteria.

#### Edge Cases to Cover
Boundary conditions, error states, empty/null inputs, race conditions.

#### What Not to Test
Trivial code, generated code, third-party wrappers, obvious one-liners.

### Principles
- Follow testing pyramid: many unit, fewer integration, few e2e
- Prioritize by risk: critical paths, error-prone areas, shared utilities
- Choose lowest test level that meaningfully verifies behavior
- Consider flakiness — prefer deterministic tests
- Weigh maintenance cost against value
- Flag areas where coverage is misleading

## Writing Tests

> Write unit, integration, and E2E tests — follow project patterns, cover edge cases, stay deterministic.

### When to use

Use this skill when you need tests written for new or existing code, want to improve test coverage, or need to fix flaky tests.

### Core principles

- Follow the testing pyramid: many unit, fewer integration, few e2e
- Prioritize by risk: critical paths, error-prone areas, shared utilities
- Test behavior, not implementation details
- Each test should have one clear reason to fail
- Name tests clearly: `should <expected behavior> when <condition>`
- Cover edge cases: boundary conditions, error states, empty/null inputs
- Write deterministic tests — no timing dependencies, no shared mutable state
- Prefer real implementations over mocks where practical

### What to test

#### Unit tests
- Pure logic, utilities, hooks, helper functions
- Focus on inputs → outputs
- Mock only external dependencies

#### Integration tests
- Component interactions, API calls, state flows
- Test multiple units working together
- Use real implementations where possible

#### E2E tests
- Critical user paths only
- Test from the user's perspective
- Use real browser/device when possible

### Test setup patterns

#### General setup
```ts
describe('feature: myComponent', () => {
  let wrapper: ReturnType<typeof mount>

  beforeEach(() => {
    wrapper = mountComponent()
  })
})
```

#### Naming conventions
- `describe` = feature or component name
- `it` / `test` = behavior description starting with "should"
- Group related tests in nested `describe` blocks

### What to avoid

- Brittle tests that depend on implementation details
- Snapshot tests for large or frequently changing components
- Testing third-party library behavior
- Skipped or commented-out tests
- Flaky tests with timing dependencies
- 100% coverage as a goal — focus on high-risk areas
