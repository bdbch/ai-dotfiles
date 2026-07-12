---
name: "accessibility-audit"
description: "WCAG 2.1/2.2 accessibility audit — keyboard navigation, screen reader, color contrast, ARIA, semantic HTML."
---

# Accessibility Audit

> WCAG 2.1/2.2 accessibility audit — keyboard navigation, screen reader, color contrast, ARIA, semantic HTML.

## When to use

Use this skill when you need a WCAG accessibility audit of a web page or component. Covers keyboard navigation, screen reader output, color contrast, heading hierarchy, ARIA usage, form labels, focus management, and responsive accessibility.

## How to audit

1. Get the URL and confirm with user before opening browser
2. Open the page in Chrome MCP
3. Take a full-page screenshot and viewport snapshot
4. Test keyboard navigation (Tab, Shift+Tab, Enter, Space, Escape, arrows)
5. Check console for errors
6. Test at multiple viewport sizes (desktop, tablet, mobile)
7. Inspect component states (hover, focus, active, disabled, error)

## Audit dimensions

### Perceptibility (WCAG Principle 1)
- Color contrast: 4.5:1 (AA), 7:1 (AAA), large text 3:1
- Text alternatives for images
- Captions and transcripts
- Color independence
- Resize and reflow at 200% zoom

### Operability (WCAG Principle 2)
- Keyboard accessibility for all interactive elements
- Visible focus indicators (minimum 2px contrast)
- Logical focus order, no unexpected trapping
- Skip-to-content link
- Respects `prefers-reduced-motion`
- Touch targets minimum 44x44px

### Understandability (WCAG Principle 3)
- Page language declared
- Visible, persistent form labels
- Consistent navigation
- Predictable behavior
- Error prevention for destructive actions

### Robustness (WCAG Principle 4)
- Semantic HTML (button, nav, main, header, footer, headings hierarchy)
- ARIA used correctly — prefer native HTML
- Live regions for dynamic content
- Name, role, value for custom components

## Common failures to look for
- Div/span as button without keyboard handler or ARIA role
- Missing label/input association
- Low contrast text
- Focus outline removed without replacement
- Skipped heading levels
- Form errors not associated with fields
- Modals that don't trap focus
- Links with non-descriptive text ("click here")

## Output format

### 1. Summary
Overall assessment, estimated WCAG level, most critical issues.

### 2. Findings table
| WCAG Criterion | Issue | Severity | Location | Description | Recommendation |

### 3. Compliance summary
| WCAG Level | Status | Notes |
