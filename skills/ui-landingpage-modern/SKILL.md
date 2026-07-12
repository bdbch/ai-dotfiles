---
name: "ui-landingpage-modern"
description: "Design premium, editorial-style landing pages — marketing sites, product pages, pricing pages, and SaaS website sections."
---

# Modern Landing Page Design Skill

Use this skill when creating modern marketing sites, product landing pages, pricing pages, feature pages, changelog pages, product launch pages, and polished SaaS website sections with the calm, premium, editorial, high-contrast aesthetic shown in the reference screenshots.

The goal is not to copy a specific brand or color palette. The goal is to reproduce the design quality: precise spacing, restrained typography, soft depth, disciplined layout, strong hierarchy, product-led storytelling, and a sense that every element has a reason to exist.

## Core aesthetic

The visual language should feel:

- Premium, quiet, technical, and focused.
- Spacious, but not empty.
- Minimal, but not generic.
- Product-led, not decoration-led.
- Editorial in rhythm: large sections, measured copy, carefully staged visuals.
- Dense enough to feel useful, but visually calm.
- Modern SaaS, not startup-template loudness.

Avoid:

- Oversized hero sections with generic gradient blobs.
- Random colorful cards without system logic.
- Loud shadows, heavy borders, glassmorphism everywhere, or excessive animation.
- Generic marketing clichés like “next generation”, “revolutionary”, “seamless”, “unlock your potential”.
- Visual clutter that competes with the product screenshots.

## Page structure principles

Build the page as a sequence of focused sections. Each section should communicate one product idea.

A strong structure usually looks like this:

1. Minimal navigation.
2. Hero with precise claim and product visual.
3. Logo strip or credibility signal.
4. Short product positioning paragraph.
5. Three concise value pillars.
6. Repeated feature story sections.
7. Changelog, integrations, testimonials, pricing, or comparison modules.
8. Final call to action.
9. Sparse footer.

Each section should have a clear job. Do not add sections just to make the page longer.

## Layout system

Use a centered page shell with a narrow content rhythm.

Recommended layout rules:

- Outer page padding: `24px` on mobile, `32px` to `48px` on desktop.
- Main content max width: usually `1040px` to `1200px`.
- Text-heavy content width: `520px` to `680px`.
- Product screenshot width: often `720px` to `960px`.
- Section vertical spacing: `96px` to `180px`, depending on importance.
- Internal section spacing: `24px` to `64px`.
- Grid gaps: `16px`, `24px`, or `32px`, not arbitrary values.

The screenshots use a strong centered spine. Most major content aligns to the same invisible column. Even when sections are asymmetric, they still feel anchored.

## Section rhythm

Use a slow, deliberate vertical rhythm.

Do:

- Let major sections breathe.
- Place headings and descriptions close enough to read as one unit.
- Use product visuals as the main visual punctuation.
- Alternate section types to avoid monotony: centered hero, two-column feature, wide screenshot, card grid, pricing table, CTA.

Do not:

- Stack too many equal-height cards in a row without hierarchy.
- Put every section in the same layout.
- Use tight landing-page spacing that feels like a dashboard.

A good rule: when scrolling, the user should feel they are moving through a product narrative, not a component gallery.

## Typography

Typography should be sharp, restrained, and highly legible.

Recommended type direction:

- Use a modern grotesk or system sans-serif.
- Keep letter spacing tight but readable.
- Use strong contrast between heading and body, not many intermediate sizes.
- Prefer short lines and compact copy.

Suggested scale:

- Hero heading: `44px` to `72px` desktop, `36px` to `48px` tablet, `32px` to `40px` mobile.
- Section heading: `28px` to `44px`.
- Feature heading: `20px` to `28px`.
- Body: `14px` to `17px`.
- Caption/meta: `11px` to `13px`.

Use lower line heights for headings:

- Hero: `0.95` to `1.08`.
- Section heading: `1.05` to `1.15`.
- Body: `1.45` to `1.7`.

Copy should feel direct and specific. Avoid paragraphs that are too wide. A good supporting paragraph usually fits into 2 to 4 lines.

## Copy style

Write like a product team explaining a serious tool.

Good copy traits:

- Specific.
- Functional.
- Calm.
- Short.
- Product-aware.
- Free of hype.

Example heading patterns:

- “Define the product direction”
- “Review code and agent output”
- “Understand progress at scale”
- “Manage incoming work with triage”
- “Build what customers actually want”

Example body copy pattern:

```text
Turn scattered feedback into structured work. Triage requests, group related issues, and keep teams focused on the highest-impact problems.
```

Avoid vague copy:

```text
Empower your team with a revolutionary platform that unlocks productivity.
```

## Color and contrast

The reference aesthetic often uses dark interfaces, but the skill should work in dark or light mode.

Principles:

- Use a restrained neutral palette.
- Let contrast and spacing do most of the work.
- Use accent colors sparingly for status, focus, highlights, active states, and small CTAs.
- Product screenshots can contain more color than the surrounding page.
- Backgrounds should be quiet.

Dark mode direction:

- Page background: near-black, not pure black.
- Surfaces: slightly lifted dark grays.
- Borders: subtle, low-alpha light borders.
- Text: high-contrast white for headings, muted gray for body.
- Accents: used in tiny, intentional doses.

Light mode direction:

- Page background: warm white or neutral white.
- Surfaces: slightly off-white or very light gray.
- Borders: soft neutral borders.
- Text: near-black, not pure black.
- Accents: restrained and functional.

Avoid large saturated gradients unless they are extremely subtle and serve the product visual.

## Surfaces, borders, and depth

Use depth carefully. The reference style relies on very subtle layering.

Recommended techniques:

- Thin borders with low opacity.
- Soft inner highlights.
- Radial lighting behind product screenshots.
- Mild background gradients from top to bottom.
- Slightly elevated cards with low-contrast shadows.
- Dim overlays to push secondary UI backward.

Do not use large generic drop shadows. Use shadow mostly to separate dark surfaces from dark backgrounds.

Good surface recipe for dark mode:

```css
background: linear-gradient(180deg, rgba(255,255,255,0.055), rgba(255,255,255,0.025));
border: 1px solid rgba(255,255,255,0.08);
box-shadow: 0 24px 80px rgba(0,0,0,0.45);
```

Good surface recipe for light mode:

```css
background: linear-gradient(180deg, rgba(255,255,255,1), rgba(248,248,248,1));
border: 1px solid rgba(0,0,0,0.08);
box-shadow: 0 24px 80px rgba(0,0,0,0.08);
```

## Product screenshots

Product screenshots are the hero asset. Treat them like editorial objects, not raw images.

Rules:

- Place screenshots inside a clean frame when needed.
- Use soft radial light behind the screenshot.
- Keep screenshots crisp and aligned.
- Let important screenshots be large.
- Crop intentionally when showing detail.
- Use overlays, floating panels, or zoomed fragments to guide attention.
- Avoid showing too many tiny unreadable screenshots.

A strong product screenshot block often has:

- A wide screenshot centered in the section.
- A subtle glow or backdrop behind it.
- A small caption or two supporting points underneath.
- Enough whitespace around it that it feels important.

## Hero sections

The hero should be direct and product-led.

Recommended composition:

- Small nav above.
- Centered or slightly left-aligned heading.
- Short product claim.
- One concise supporting paragraph.
- One or two compact CTAs.
- Large product screenshot below.

Hero should avoid excessive decoration. The product UI should be the main visual proof.

Example hero structure:

```html
<section class="hero">
  <p class="eyebrow">Product operations for modern teams</p>
  <h1>The system for building products with teams and agents.</h1>
  <p>Plan, triage, review, and ship work from one focused workspace.</p>
  <div class="actions">...</div>
  <div class="hero-visual">...</div>
</section>
```

Hero spacing:

- Nav to hero content: `72px` to `120px`.
- Heading to paragraph: `16px` to `24px`.
- Paragraph to CTAs: `24px` to `36px`.
- CTAs to screenshot: `48px` to `80px`.

## Navigation

Navigation should feel almost invisible.

Rules:

- Keep it short.
- Use small text.
- Keep the logo simple.
- Use compact buttons.
- Avoid huge nav bars.
- Preserve enough top padding.

Desktop nav pattern:

- Logo left.
- Small nav links centered or right.
- Primary compact pill button on the far right.

Mobile nav pattern:

- Logo left.
- Menu button right.
- Avoid overdesigned mobile menus unless needed.

## Feature sections

Feature sections should pair a product capability with a visual proof.

Common layouts:

1. Two-column intro above a screenshot.
2. Left heading, right description, full-width visual below.
3. Narrow text column next to a large product panel.
4. Feature grid with one dominant card and smaller supporting details.

For feature narratives:

- Start with a direct heading.
- Explain the practical value in 1 to 3 sentences.
- Show the UI doing the thing.
- Add small details below if necessary.

Example:

```text
Manage incoming work with triage

Route requests into the right workflow before they disrupt the roadmap. Group duplicates, clarify ownership, and turn signals into actionable issues.
```

## Cards

Cards should feel like structured information, not decorative blocks.

Good card traits:

- Subtle borders.
- Minimal shadow.
- Clear title.
- Short description.
- Optional icon or small UI detail.
- Strong alignment.
- Enough padding.

Recommended card padding:

- Small card: `20px` to `28px`.
- Medium card: `28px` to `40px`.
- Large feature card: `40px` to `64px`.

Card radius:

- Use `12px` to `20px`.
- Product UI surfaces can use smaller radii like `8px` to `12px`.

Avoid cards that look like generic SaaS templates with oversized icons and center-aligned marketing copy everywhere.

## Icons and marks

Icons should be small, thin, and technical.

Rules:

- Use line icons or simple geometric symbols.
- Keep icons monochrome or low-contrast unless they communicate status.
- Use icons as labels, not decoration.
- Avoid large cartoon icons.
- Avoid mixed icon styles.

For feature pillars, icons can be abstract, but should feel consistent and architectural.

## Buttons and links

Buttons should be compact and intentional.

Primary CTA:

- Small to medium pill.
- High contrast.
- Clear label.
- Often paired with a secondary ghost button.

Secondary actions:

- Ghost or subtle filled button.
- Low visual weight.

Text links:

- Use concise labels.
- Add a subtle arrow only when it helps imply navigation.
- Keep text links aligned on a clear baseline.

Avoid huge buttons unless the page has a consumer-product feel.

## Pricing pages

Pricing should be clear, restrained, and easy to scan.

Recommended structure:

1. Page title.
2. Pricing cards in 3 or 4 columns.
3. Short customer/logo strip.
4. Feature comparison table.
5. Final CTA.

Pricing card rules:

- Keep card chrome minimal.
- Use clear plan names.
- Use price hierarchy strongly.
- Use short feature lists.
- Highlight the recommended tier with contrast, not loud color.
- Keep enterprise visually aligned with other cards.

Feature table rules:

- Use section groups.
- Use subtle horizontal spacing and vertical separators.
- Use checkmarks and text sparingly.
- Avoid heavy table borders.
- Keep row height comfortable.
- Make plan columns sticky on mobile only if implementation complexity is justified.

## Changelog and update modules

Changelog sections should feel lightweight.

Rules:

- Use a simple heading.
- Show updates as compact columns or timeline items.
- Use dates or labels as small muted text.
- Keep descriptions concise.
- Link to the full changelog.

Do not overdesign changelog cards. They should feel like proof of momentum, not the main page event.

## Logo strips and social proof

Logo strips should be understated.

Rules:

- Use monochrome logos.
- Keep opacity controlled.
- Align logos on a consistent baseline.
- Avoid large, colorful logo walls.
- Use only when they support credibility.

The social proof should not interrupt the main product narrative.

## Final CTA

The final CTA should be simple and confident.

Recommended composition:

- Centered short heading.
- One sentence or no paragraph.
- One primary button and one secondary action.
- Large whitespace around it.

Example:

```text
Built for the future.
Available today.
```

This kind of CTA works because it is short, confident, and visually memorable.

## Footer

Footer should be sparse and structured.

Rules:

- Keep the logo small.
- Use columns with short link groups.
- Use muted text.
- Keep legal links minimal.
- Add generous top padding.
- Avoid dense newsletter boxes unless necessary.

## Responsive behavior

Design mobile first, but preserve the premium feel on small screens.

Mobile rules:

- Collapse multi-column layouts into one column.
- Keep hero heading large but not overwhelming.
- Reduce section spacing, but do not make it cramped.
- Keep screenshots horizontally scrollable only when useful. Prefer responsive scaling.
- Hide non-essential decorative overlays.
- Preserve text readability with line lengths around `32` to `55` characters.

Recommended mobile spacing:

- Section padding: `72px` to `112px`.
- Internal gaps: `20px` to `40px`.
- Card padding: `20px` to `28px`.

## Motion and interaction

Use motion sparingly.

Good motion:

- Subtle fade and translate on section reveal.
- Small hover lift on cards.
- Button background transitions.
- Product UI highlight animations.
- Smooth scrolling only when it does not harm accessibility.

Bad motion:

- Large parallax effects.
- Constant moving gradients.
- Delayed content that slows reading.
- Scroll hijacking.
- Overanimated nav or buttons.

Motion should make the interface feel polished, not theatrical.

## Implementation checklist

Before finalizing a landing page, verify:

- The page has one strong product claim.
- Every section has a specific job.
- Spacing follows a consistent scale.
- Typography has clear hierarchy.
- Body text is readable and short.
- Product screenshots are large enough to understand.
- Decorative effects are subtle.
- Buttons are compact and clear.
- Mobile layouts are not an afterthought.
- The page still works without animations.
- The page avoids generic SaaS hype.

## Tailwind direction

When implementing with Tailwind, prefer a small design system using tokens.

Example token direction:

```js
const theme = {
  colors: {
    page: 'hsl(0 0% 4%)',
    surface: 'hsl(0 0% 7%)',
    surfaceElevated: 'hsl(0 0% 10%)',
    border: 'hsl(0 0% 100% / 0.08)',
    text: 'hsl(0 0% 98%)',
    muted: 'hsl(0 0% 64%)',
    subtle: 'hsl(0 0% 42%)',
    accent: 'hsl(75 100% 50%)'
  },
  borderRadius: {
    panel: '18px',
    control: '999px'
  }
}
```

Useful Tailwind patterns:

```html
<section class="mx-auto max-w-6xl px-6 py-28 md:px-10 md:py-40">
  <div class="mx-auto max-w-2xl text-center">
    <h1 class="text-4xl font-medium tracking-tight text-white md:text-6xl md:leading-[0.98]">
      The product system for focused teams.
    </h1>
    <p class="mt-5 text-base leading-7 text-white/60">
      Plan, triage, review, and ship product work from one calm workspace.
    </p>
  </div>
</section>
```

```html
<div class="rounded-2xl border border-white/10 bg-white/[0.035] shadow-[0_24px_80px_rgba(0,0,0,0.45)]">
  ...
</div>
```

```html
<div class="pointer-events-none absolute inset-x-0 top-0 h-96 bg-[radial-gradient(circle_at_top,rgba(255,255,255,0.12),transparent_60%)]" />
```

## Quality bar

A successful result should feel like it belongs to a serious product company. It should be elegant, intentional, and calm. It should not feel like a template, a Dribbble shot, or a generic AI-generated landing page.
