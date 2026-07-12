---
name: "browser-design-review"
description: "Open a website in the browser and perform a senior UI/UX design critique, highlighting what works, what doesn't, and actionable improvements."
---

# Browser Design Review

> Open a website in the browser and perform a senior UI/UX design critique, highlighting what works, what doesn't, and actionable improvements.

## When to use

Use this skill when you want a professional UI/UX design review of a website or web application. The agent acts as a senior designer, using the Chrome MCP to open the page, inspect it visually and structurally, then provide structured critique and actionable recommendations.

This is useful for:
- Reviewing a design before launch
- Getting a fresh perspective on an existing site
- Identifying usability issues and conversion blockers
- Benchmarking against design best practices
- Generating ideas for redesigns or improvements

## How to review

1. **Get the URL**: If the user provided a URL, use it. If not, ask the user for the URL to review.
2. **Confirm before opening**: Ask the user if they want you to open Chrome. Do not open any URL without explicit permission.
3. **Open the page**: Use the Chrome MCP (`Google_Chrome_MCP_navigate_page` or `Google_Chrome_MCP_new_page`) to open the URL.
4. **Wait for the page to load**: Use `Google_Chrome_MCP_wait_for` to ensure the page has loaded.
5. **Take a full-page screenshot**: Use `Google_Chrome_MCP_take_screenshot` with `fullPage: true` to capture the entire page.
6. **Take a viewport snapshot**: Use `Google_Chrome_MCP_take_snapshot` to understand the page structure and interactive elements.
7. **Resize and repeat**: If appropriate, resize the viewport with `Google_Chrome_MCP_resize_page` to test responsive behavior (e.g., tablet at 768x1024, mobile at 375x812) and take additional screenshots.
8. **Iterate on interactive elements**: Click buttons, open menus, fill forms, or navigate to key sub-pages using the Chrome MCP to review the full experience.

## What to look out for

When reviewing, consider the following dimensions from the perspective of a senior UI/UX designer:

### Visual Design
- **Visual hierarchy**: Does the page clearly communicate what matters most? Is there a clear focal point?
- **Typography**: Is the type scale coherent? Are heading/text sizes, line heights, and font choices appropriate?
- **Color palette**: Are colors used consistently and meaningfully? Is there sufficient contrast? Does the palette support the brand?
- **Spacing & layout**: Is there consistent rhythm and breathing room? Are grids used effectively?
- **Imagery & iconography**: Do images and icons serve a purpose? Are they high quality and consistent in style?
- **Consistency**: Are UI patterns, button styles, and component treatments consistent across the page/site?

### Usability
- **Navigation**: Can users easily find what they're looking for? Is the navigation clear, concise, and predictable?
- **Scannability**: Is content easy to scan with clear headings, bullet points, and visual anchors?
- **Forms & inputs**: Are form fields clearly labeled? Are error states handled gracefully?
- **Feedback & affordance**: Do buttons and interactive elements clearly signal their purpose? Is there feedback on interaction (hover, active, loading states)?
- **Accessibility**: Are there obvious accessibility issues (low contrast, missing alt text, small touch targets)?
- **Mobile responsiveness**: Does the design work well across viewport sizes? Are touch targets large enough?

### Information Architecture
- **Content clarity**: Is the messaging clear and concise? Does it speak to the target audience?
- **Call-to-action (CTA) prominence**: Are primary actions easy to find and irresistible?
- **Cognitive load**: Is the page overwhelming or well-paced? Can users absorb information progressively?

### Performance & Technical
- **Loading state**: Are loading indicators shown? Is there content shift (CLS) as the page loads?
- **Perceived performance**: Do images and resources load progressively? Is there a skeleton or placeholder state?

### Overall Experience
- **First impression**: What is the emotional response when landing on the page?
- **Brand alignment**: Does the design reflect the brand's personality and values?
- **Delight**: Are there moments of delight, micro-interactions, or thoughtful details?

## What to respond

Structure the response in three sections:

### 1. Summary

A brief 2-4 sentence overall assessment of the site's design. Start with what works well, then note the main areas for improvement. Maintain a constructive, professional tone.

### 2. What works well

A short bullet list of 2-4 things the site does well — design choices worth preserving or celebrating.

### 3. Actionable feedback table

| Category | Issue | Severity | Description | Recommendation |
|----------|-------|----------|-------------|----------------|
| Visual Design | | 🔴 High / 🟡 Medium / 🟢 Low | | |
| Usability | | | | |
| IA / Content | | | | |
| Responsive | | | | |
| Accessibility | | | | |
| Performance | | | | |

- **Category**: The design dimension the issue falls under (Visual Design, Usability, IA/Content, Responsive, Accessibility, Performance).
- **Issue**: A short name for the finding.
- **Severity**: 🔴 High (must fix), 🟡 Medium (should fix), 🟢 Low (nice to have).
- **Description**: What was observed and why it matters.
- **Recommendation**: A concrete, actionable suggestion for improvement.

Keep descriptions and recommendations concise and specific. Avoid vague advice like "make it better" — instead say "increase heading font size to 2rem and add 32px margin below."

### 4. Ideas & inspirations

A short bullet list of 1-3 creative ideas, inspirations, or experiments the team could explore — not necessarily to implement as-is, but to provoke thinking.

| Idea | Description | Why it could work |
|------|-------------|-------------------|
| | | |
