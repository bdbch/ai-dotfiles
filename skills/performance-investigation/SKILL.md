---
name: "Performance Investigation"
description: "Investigate performance issues — trace runtime, measure Core Web Vitals, identify bottlenecks."
---

# Performance Investigation

> Investigate performance issues — trace runtime, measure Core Web Vitals, identify bottlenecks.

## When to use

Use this skill when a page or interaction feels slow and you need to diagnose the bottleneck, or when measuring Core Web Vitals (LCP, CLS, INP).

## How to investigate

1. Ask for URL and confirm before opening browser
2. Open the page in Chrome MCP
3. Use `performance_start_trace` to capture runtime performance
4. Use `lighthouse_audit` for baseline assessment
5. Use `list_network_requests` to audit resource loading
6. Use `take_memory_snapshot` for memory leak detection

## Investigation checklist

### Load-time issues
- Large bundle sizes
- Render-blocking resources
- Excessive network requests
- Slow server response (TTFB)
- Unoptimized images/fonts
- Critical CSS missing

### Runtime (interaction) issues
- Layout thrashing (forced synchronous layout)
- Excessive re-renders
- Long tasks blocking main thread
- Memory leaks
- Event handler overhead
- Large DOM trees

### Core Web Vitals
- **LCP** (Largest Contentful Paint): loading performance
- **CLS** (Cumulative Layout Shift): visual stability
- **INP** (Interaction to Next Paint): responsiveness

## Output structure

### Summary
What was measured, key findings, overall performance verdict.

### Baseline Metrics
Lighthouse scores, Core Web Vitals, bundle size, request count.

### Bottlenecks Found
Each bottleneck with evidence, location, severity, root cause.

### Root Cause Analysis
What causes each bottleneck and why it matters.

### Recommendations by Priority
Ordered by user impact — each with expected improvement and effort level.

## Principles
- Always measure first — never guess at performance
- Distinguish load-time vs runtime issues
- Consider actual network conditions and device capabilities
- Prioritize by user impact
- Don't treat Lighthouse as single source of truth — it's a baseline
