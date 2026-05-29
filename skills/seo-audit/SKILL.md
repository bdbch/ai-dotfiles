---
name: "SEO Audit"
description: "Technical SEO audit — meta tags, structured data, Core Web Vitals, mobile-first indexing, content optimization."
---

# SEO Audit

> Technical SEO audit — meta tags, structured data, Core Web Vitals, mobile-first indexing, content optimization.

## When to use

Use this skill when you need an SEO audit: meta tags, structured data, sitemaps, heading structure, performance signals, or content optimization.

## How to audit

1. Ask for target keywords if not provided
2. Open the page in Chrome MCP (confirm with user first)
3. Run Lighthouse for baseline SEO and performance scores
4. Inspect the rendered page, DOM, meta tags, structured data
5. Research SERP results and competitor pages if needed

## Audit dimensions

### On-page SEO
- `<title>` tag: length, keyword placement, branding
- Meta description: length, persuasiveness
- Open Graph and Twitter Card tags
- Canonical URL, hreflang tags
- URL structure: readable, keyword-inclusive
- Image alt attributes
- Heading hierarchy: logical h1–h6, one h1 per page

### Technical SEO
- Structured data (JSON-LD, microdata): type, syntax, Rich Results eligibility
- Sitemap presence and accuracy
- robots.txt configuration
- HTTPS enforcement, mixed content
- Status codes: 200 on live, proper 301s, no soft 404s
- JavaScript rendering: content visible after JS execution
- Core Web Vitals: LCP, CLS, INP

### Content optimization
- Keyword presence and placement
- Content depth vs competitors
- Readability and sentence structure
- Internal links and anchor text
- Freshness signals

### Mobile SEO
- Viewport configuration
- Tap target sizing (44x44px minimum)
- Font size legibility
- Content-width fitting
- Mobile vs desktop content parity

## Output format
JSON with:
- Summary: overall verdict, scores, confidence
- On-page SEO issues with severity
- Technical SEO issues
- Content optimization issues
- Keyword clusters and gaps
- Core Web Vitals from Lighthouse
- Priority actions (3-5 items)

## Principles
- Audit the real rendered page, not source code alone
- Always run Lighthouse
- Don't fabricate scores — always measure
- Don't suggest manipulative tactics
- Be specific: "Change title from X to Y" not "Improve titles"
