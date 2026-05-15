---
name: "Browser Test"
description: "Use the Chrome browser to manually test a feature end-to-end — navigate, click, type, and verify behavior like a human QA engineer."
---

# Browser Tester

> Use the Chrome browser to manually test a feature end-to-end — navigate, click, type, and verify behavior like a human QA engineer.

## When to use

Use this skill when you need to verify that a feature works correctly by manually executing test steps in the browser. Unlike the Browser Debugger (which finds root causes of known issues), this skill follows a spec step by step and reports pass/fail for each assertion.

This is useful for:
- Testing a new feature before release
- Reproducing a bug report by following reproduction steps
- Verifying a fix works as expected
- Exploring an application to understand its behavior
- Regression testing after changes
- Reviewing a pull request that has UI changes

## How to test

1. **Understand the spec**: Read the user's feature description, bug report, or test scenario. Identify the key actions and expected outcomes.
2. **Ask for clarification if needed**: If the spec is ambiguous or missing critical details (URL, credentials, test data), ask the user before proceeding.
3. **Open the page**: Use `Google_Chrome_MCP_new_page` (with optional `isolatedContext` for login state isolation) to open the application URL.
4. **Execute each step sequentially**: For each step in the test scenario, perform the action and verify the result before moving on.
5. **Inspect the UI state**: After each action, use `Google_Chrome_MCP_take_snapshot` to read the current page state and verify expected elements are present.
6. **Capture evidence**: Use `Google_Chrome_MCP_take_screenshot` to document key states — before interaction, after interaction, success states, error states.
7. **Check for errors**: Periodically use `Google_Chrome_MCP_list_console_messages` to catch JavaScript errors that occur during testing.
8. **Report results**: After all steps, summarize what passed, what failed, and any observations.

## What to test for

### Functional Correctness
- Does the UI render the expected elements after each action?
- Do forms submit correctly with valid data?
- Do forms show appropriate errors with invalid data?
- Do buttons, links, and interactive elements trigger the correct behavior?
- Does navigation work as expected (routes, back/forward, deep links)?

### State Management
- Does page state persist correctly after actions (e.g., form data, filters, selections)?
- Does refreshing the page preserve or reset state as expected?
- Do multi-step flows (wizards, checkout) maintain correct state across steps?
- Do optimistic updates reflect the final server state?

### Edge Cases
- Empty states: What happens when there's no data to display?
- Error states: What happens when a network request fails?
- Loading states: Are loading indicators shown during async operations?
- Boundary values: What happens with very long inputs, special characters, or unusual data?
- Authentication: Does unauthenticated access redirect to login? Does session expiry behave correctly?

### Responsive Behavior
- Does the feature work on mobile viewport sizes?
- Do modals, drawers, and overlays render correctly at different widths?
- Do touch interactions work on mobile viewport?

### Feedback & Affordance
- Do buttons show loading states during async operations?
- Do success/error toasts or messages appear after actions?
- Are disabled states visually clear?
- Are hover, focus, and active states visible on interactive elements?

## What to respond

Structure the response in three sections:

### 1. Summary

A brief 2-3 sentence overview: how many steps passed/failed, the overall verdict, and the most important finding.

### 2. Step-by-step results

| # | Action | Expected | Actual | Status |
|---|--------|----------|--------|--------|
| 1 | | | | ✅ Pass / ❌ Fail / ⚠️ Warning |

- **#**: Step number (matching the test scenario order).
- **Action**: What was done (e.g., "Clicked 'Sign In' button", "Typed 'test@example.com' into email field").
- **Expected**: What should happen according to the spec.
- **Actual**: What actually happened (include observed UI state, console messages, network responses).
- **Status**: ✅ Pass (matches expected), ❌ Fail (does not match expected), ⚠️ Warning (works but has concerns — slow, ugly, unexpected console warning).

### 3. Evidence

For each failed or warning step, include:
- A screenshot reference (describe what the screenshot shows)
- Any relevant console errors or network request details
- The observed vs expected difference

### 4. Overall assessment

- **Pass rate**: X/Y steps passed.
- **Critical issues**: Any failures that block the feature from shipping.
- **Minor issues**: Cosmetic concerns, non-blocking warnings.
- **Recommendation**: Ship as-is, ship with fixes, or block until resolved.
