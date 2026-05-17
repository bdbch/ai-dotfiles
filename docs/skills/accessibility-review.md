# Accessibility Review

Systematic WCAG accessibility audit using browser tools — keyboard navigation, screen reader compatibility, color contrast, ARIA, and semantic HTML.

## When to Use

- Pre-launch accessibility audit
- Checking WCAG 2.1 AA compliance
- Debugging keyboard navigation gaps
- Verifying color contrast ratios
- Evaluating ARIA usage correctness
- Testing screen reader compatibility

## Audit Process

1. **Get the URL** from the user or ask for it
2. **Open the page** in a fresh browser tab
3. **Check keyboard navigation** — Tab, Shift+Tab, Enter, Space, Escape, arrow keys
4. **Inspect the accessibility tree** using browser snapshots
5. **Verify color contrast** for all text elements
6. **Check heading hierarchy** — proper nesting and semantic structure
7. **Review ARIA usage** — correct roles, states, and properties
8. **Test screen reader** compatibility by analyzing the a11y tree
9. **Identify form labeling** issues — missing or incorrect label associations
10. **Check focus management** — visible focus indicators, logical order

## Output

A structured audit report with:

- **Summary** — overall WCAG level, critical issues count
- **Findings Table** — WCAG criterion, issue description, severity, location, fix recommendation
- **Compliance Summary** — pass/fail status per conformance level (A, AA, AAA)
