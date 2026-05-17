# Browser Test

Use the Chrome browser to manually test a feature end-to-end — navigate, click, type, and verify behavior like a human QA engineer.

## When to Use

- Testing a new feature before release
- Reproducing a bug report
- Verifying a bug fix
- Regression testing after changes
- Reviewing a pull request with UI changes

## Test Process

1. **Get the URL, credentials, and test data** from the user
2. **Open the page** in an isolated browser context
3. **Execute test steps sequentially** using snapshots to read UI state
4. **Capture screenshots** as evidence at each step
5. **Check for JavaScript errors** periodically
6. **Report results** with pass/fail verdicts

## Output

A test report with:

- **Summary** — overall pass rate and critical issues
- **Step-by-Step Results** — table with Action, Expected, Actual, Status
- **Evidence** — screenshots and console logs for failures
- **Overall Assessment** — recommendation (approve, needs fixes, blocks release)
