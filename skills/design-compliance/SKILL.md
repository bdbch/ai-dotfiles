---
name: "Design Compliance"
description: "Strict design compliance audit — measurable standards only: contrast ratios, spacing grid, typography scale, hit targets."
---

# Design Compliance

> Strict design compliance audit — measurable standards only: contrast ratios, spacing grid, typography scale, hit targets.

## When to use

Use this skill when you need a strict, repeatable design compliance check — no opinion, just measurable standards. Catches visual inconsistencies, accessibility violations, spacing grid deviations, and component drift.

## How to audit

1. Get the URL and confirm with user before opening browser
2. Open the page in Chrome MCP
3. Take screenshots and snapshots
4. Measure and verify against standards

## Audit dimensions

### 1. Contrast audit
- Measure foreground/background contrast ratios against WCAG AA (4.5:1 normal, 3:1 large, 3:1 UI components)
- Check all text, icons, input borders, focus indicators, placeholder text
- Report exact measured contrast ratios

### 2. Spacing grid audit
- Detect the project's spacing unit (4px, 8px, etc.)
- Flag any spacing value that doesn't conform to the grid
- Ignore intentional asymmetric layouts only with clear structural reason

### 3. Typography audit
- Identify font stack from computed styles
- Check font sizes follow a consistent scale
- Verify line-height is set (not default browser 1.2)
- Flag mix of too many typefaces (3+ is a warning, 4+ is a fail)

### 4. Component consistency audit
- Inventory repeated UI patterns (buttons, cards, inputs, modals)
- Check all instances share same border-radius, padding, font-size, color, shadow
- Flag variants that serve same purpose but look different

### 5. Hit target audit
- Measure all interactive elements against 44x44px minimum (WCAG 2.5.8)
- Flag any clickable element below the minimum with measured dimensions

### 6. Responsive breakpoint audit
- Test at 375px (mobile), 768px (tablet), 1440px (desktop)
- Report layout breakage, content cutoff, horizontal overflow

### 7. Design token alignment
- Check for CSS custom properties, design tokens, theme system
- Report hardcoded values that should be tokens
- Flag inconsistent token usage

## Output format
JSON with compliance checks, each with:
- Category, criterion, status (pass/fail/not_applicable)
- Location, expected value, measured value
- Pass rate: ≥90% = pass, 70-89% = pass_with_notes, <70% = fail

## Principles
- Every finding must include expected value and measured value
- If you cannot measure it, do not report it
- Report exact pass/fail — no "mostly" or "almost"
- Do not express aesthetic opinions — only measurable standards
