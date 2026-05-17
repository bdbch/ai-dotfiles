# Code Review

Review code and provide feedback around best practices, potential bugs or regression, and overall code quality.

## When to Use

- After completing a feature implementation
- After fixing a bug
- After refactoring a module
- When reviewing a pull request
- Before merging changes to main

## Review Process

1. **Understand the changes** — read the diff or full files
2. **Analyze correctness** — does the code do what it's supposed to?
3. **Check for bugs** — edge cases, error handling, race conditions
4. **Evaluate maintainability** — is the code easy to understand and modify?
5. **Review test coverage** — are there tests for the changed paths?
6. **Assess security** — input validation, data exposure, auth
7. **Check performance** — unnecessary work, expensive operations
8. **Verify consistency** — does it follow project conventions?

## Output

A structured review with:

- **Summary** — overall quality and any blocking issues
- **Issues Found** — categorized by severity:
  - **Critical** — security flaws, data loss, incorrect behavior
  - **Major** — potential bugs, missing error handling
  - **Minor** — style, naming, documentation gaps
  - **Suggestion** — optional improvements
- **Recommendations** — actionable next steps
