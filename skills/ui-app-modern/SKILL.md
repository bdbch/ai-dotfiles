---
name: "ui-app-modern"
description: "Design modern, native-feeling web apps — SaaS workspaces, dashboards, issue trackers, admin panels, and productivity tools."
---

# Native App UI Design Skill

Use this skill when designing clean, native-feeling web apps, desktop apps, SaaS workspaces, dashboards, issue trackers, project management tools, admin panels, productivity tools, and AI-assisted product interfaces similar in structure and quality to the app screenshots.

The goal is not to copy a specific app. The goal is to create interfaces that feel fast, calm, structured, keyboard-friendly, information-dense, and native to the platform.

## Core product feel

The app should feel:

- Native, not like a marketing website.
- Calm, focused, and highly usable.
- Dense but not cluttered.
- Fast and keyboard-friendly.
- Structured around real workflows.
- Professional, not playful.
- Minimal, but with enough detail to guide the user.

Avoid:

- Dashboard-card bloat.
- Overdecorated sidebars.
- Huge empty hero-like app screens.
- Random gradients or decorative backgrounds.
- Overly colorful UI where every element competes for attention.
- Mobile-app style spacing in a desktop productivity app.

## App shell

Use a stable app shell with clear regions:

1. Sidebar.
2. Top bar or command area.
3. Main content area.
4. Optional right inspector/details panel.
5. Optional bottom input or status bar.

The user should always know where they are, what is selected, and what action is available next.

## Sidebar design

The sidebar should be functional and quiet.

Recommended structure:

- Workspace switcher at the top.
- Primary global items: Inbox, My work, Search, etc.
- Section groups with small labels.
- Team/project navigation.
- Secondary utility links near the bottom.

Sidebar rules:

- Width: usually `220px` to `280px` on desktop.
- Use small text: `12px` to `14px`.
- Use compact row heights: `28px` to `36px`.
- Keep icons small: `14px` to `16px`.
- Use subtle active states.
- Do not overuse borders.
- Use indentation to show hierarchy.

Good active state:

- Slightly lighter background.
- High-contrast text.
- Optional accent strip or icon color.

Bad active state:

- Large bright pill.
- Strong colored background.
- Heavy shadow.

## Top bar

Top bars should be compact and utility-focused.

Common contents:

- Breadcrumbs.
- Page title.
- Search or command button.
- View controls.
- Filter/sort/group controls.
- User/avatar/status icons.

Rules:

- Height: `44px` to `56px`.
- Use subtle bottom border only if it helps structure.
- Keep controls compact.
- Use icon buttons for secondary tools.
- Do not turn the top bar into a marketing nav.

## Main content area

The main area should prioritize the active workflow.

For issue lists, task lists, tables, inboxes, and queues:

- Use rows, groups, and compact metadata.
- Keep row height readable but dense.
- Use clear hover and selected states.
- Align metadata into predictable columns.
- Put the primary label/title near the left.
- Keep secondary metadata visually muted.

For detail pages:

- Use a central readable content column.
- Keep properties either in a right panel or compact header area.
- Keep comments/activity below the main content.
- Do not overload the main editor area with metadata.

## Information hierarchy

Every app screen needs a hierarchy:

1. Current location.
2. Primary object or list.
3. Status and metadata.
4. Available actions.
5. Secondary details.

Use visual weight instead of decoration:

- Primary text: high contrast.
- Secondary text: muted.
- Metadata: smaller and dimmer.
- Icons: lower contrast unless active.
- Actions: visible on hover when not primary.

## Typography

Use native-feeling type.

Recommended direction:

- System UI font stack.
- Small, precise text.
- Medium weight for selected or primary labels.
- Regular weight for body.
- Muted color for metadata.

Suggested scale:

- App chrome labels: `12px` to `13px`.
- Sidebar rows: `13px` to `14px`.
- Main list rows: `13px` to `15px`.
- Detail page title: `24px` to `32px`.
- Detail body: `14px` to `16px`.
- Metadata: `11px` to `13px`.

Line height:

- Dense UI text: `1.2` to `1.35`.
- Body/editor text: `1.45` to `1.65`.

## Spacing and density

Native-feeling apps use tighter spacing than landing pages.

Recommended spacing:

- App shell padding: `8px` to `16px`.
- Sidebar item gap: `2px` to `6px`.
- Row horizontal padding: `12px` to `20px`.
- Row vertical padding: `6px` to `10px`.
- Detail page top spacing: `40px` to `72px`.
- Detail content width: `600px` to `760px`.
- Right inspector width: `260px` to `340px`.

Use a consistent spacing scale: `4`, `8`, `12`, `16`, `24`, `32`, `48`, `64`.

## Color and theming

The UI should work in dark and light themes.

Dark mode direction:

- Main background: near-black or very dark neutral.
- Sidebar background: slightly distinct from main background.
- Panels: subtly raised.
- Active rows: low-alpha light overlay.
- Borders: low-alpha light strokes.
- Text hierarchy: white, muted gray, dim gray.

Light mode direction:

- Main background: neutral white or off-white.
- Sidebar background: very light neutral.
- Panels: white with soft borders.
- Active rows: low-alpha dark or subtle accent overlay.
- Borders: low-alpha dark strokes.
- Text hierarchy: near-black, gray, light gray.

Accent colors should communicate meaning:

- Status.
- Priority.
- Selection.
- Focus.
- Ownership.
- Warnings.

Do not use accent colors as decoration everywhere.

## Borders, dividers, and surfaces

Use borders to clarify structure, not to draw boxes around everything.

Good use cases:

- App shell separation.
- Sidebar/main boundary.
- Header/list boundary.
- Inspector panel boundary.
- Menu panel edges.
- Input fields and controls.

Bad use cases:

- Border around every row.
- Border around every icon.
- Heavy card grids inside productivity apps.

Prefer subtle dividers and background changes over strong outlines.

## Lists and issue rows

Issue/task rows should be compact and scannable.

A strong row usually includes:

- Status icon.
- Issue key or short ID.
- Title.
- Optional parent/project breadcrumb.
- Assignee/avatar.
- Estimate or points.
- Cycle/date/status metadata.

Rules:

- Keep title readable and close to the left.
- Use muted metadata after the title.
- Use icons consistently.
- Show hover actions only on hover.
- Make the full row clickable.
- Preserve keyboard focus states.

Grouped list pattern:

```text
In Progress    3
  DEV-21  Add custom fields for login       Assignee  Points  Date

Todo           11
  DEV-17  Portfolio post type               Assignee  Points  Date
  DEV-20  Implement single page gallery     Assignee  Points  Date
```

Groups should be collapsible when there are many items.

## Detail pages

Detail pages should feel like focused documents.

Recommended layout:

- Main content column centered or slightly left of center.
- Large title.
- Short description/body.
- Sub-issues/checklists below.
- Activity/comments below.
- Right properties panel.

Rules:

- Keep the title area clean.
- Metadata belongs in the side panel unless it is critical.
- Use subtle separators between content, sub-items, and activity.
- Keep comment input visible and calm.
- Do not place too many buttons near the title.

## Right inspector panel

The right panel is for object properties and secondary context.

Common sections:

- Status.
- Priority.
- Assignee.
- Estimate.
- Cycle/milestone.
- Labels.
- Project.
- Dates.
- Links/relations.

Rules:

- Width: `280px` to `340px`.
- Use grouped cards or sections.
- Use compact labels.
- Make property rows clickable.
- Keep section headers muted.
- Avoid turning it into a form-heavy sidebar unless editing is the primary task.

## Menus and command interactions

Menus should feel native.

Rules:

- Open near the trigger.
- Use compact row height: `28px` to `34px`.
- Use icons on the left only when they aid recognition.
- Use keyboard shortcuts on the right.
- Use nested menus sparingly.
- Use separators to group actions.
- Highlight the hovered item with a subtle background.
- Keep destructive actions at the bottom.

A good menu has clear structure:

```text
Change status
  Backlog
  Todo
  In Progress
  In Review
  Done
  Canceled

Create related
Mark as
Remove

Copy
Move
Open in

Delete
```

## Forms and inputs

Inputs should be quiet and efficient.

Rules:

- Use compact height: `32px` to `40px`.
- Use subtle background and border.
- Use clear placeholder text.
- Show focus states clearly.
- Avoid large form cards unless needed.
- Support keyboard submission and escape cancellation where appropriate.

For comment inputs:

- Keep them visually calm.
- Show formatting and attachment actions only when useful.
- Use a clear submit affordance.

## Empty states

Empty states should be useful, not cute.

Good empty states:

- Explain what belongs here.
- Offer one primary action.
- Keep text short.
- Use a small icon or no illustration.

Bad empty states:

- Large illustrations.
- Long motivational copy.
- Multiple competing actions.

## Status and priority systems

Status and priority should be visually encoded with restraint.

Rules:

- Use small icons, dots, or pills.
- Keep status colors consistent.
- Use labels for accessibility, not only color.
- Make active status obvious but not loud.

Example statuses:

- Backlog.
- Todo.
- In Progress.
- In Review.
- Done.
- Canceled.

Example priorities:

- No priority.
- Low.
- Medium.
- High.
- Urgent.

## Tables and data views

Tables should be functional and stable.

Rules:

- Align columns precisely.
- Keep row height consistent.
- Use sticky headers for long tables.
- Use subtle grid lines only where needed.
- Let users sort, filter, and group.
- Avoid excessive icons in every cell.

A good table feels like a native data tool, not a spreadsheet clone unless spreadsheet behavior is actually required.

## UX rules

The app should support real work.

Required UX qualities:

- Clear selected state.
- Clear hover state.
- Clear focus state.
- Keyboard shortcuts for frequent actions.
- Command menu or quick switcher for power users.
- Undo or safe confirmation for destructive actions.
- Inline editing where it is faster than opening dialogs.
- Optimistic updates where appropriate.
- Good loading and skeleton states.
- Clear error messages close to the source of the problem.

## Keyboard-first behavior

For productivity apps, keyboard support is part of the native feel.

Recommended shortcuts:

- `Cmd/Ctrl + K`: command menu.
- `C`: create item.
- `/`: search or focus filter.
- `J/K` or arrow keys: move selection.
- `Enter`: open selected item.
- `Esc`: close panel/menu/dialog.
- `Cmd/Ctrl + Enter`: submit comment/form.

Always show shortcuts in menus when useful.

## AI features in app UIs

AI should be integrated as a workflow assistant, not a separate gimmick.

Good AI UI patterns:

- Inline suggestion panels.
- Reviewable generated output.
- Diff views for changes.
- Clear source/context references.
- Human approval before applying important changes.
- Small “Ask” entry point in the relevant context.

Avoid:

- Giant chat panels that dominate the product.
- Magic buttons without explaining what will change.
- Auto-applying destructive or high-impact changes.
- Hiding the reasoning or source of generated output.

## Modals, panels, and overlays

Use overlays sparingly.

Rules:

- Prefer inline editing or side panels for workflow continuity.
- Use modals only when the user must focus on one decision.
- Keep modal width appropriate: `420px` to `640px` for most dialogs.
- Keep destructive confirmation dialogs short.
- Avoid full-screen modals unless the task is complex.

## Responsive and desktop-first behavior

Many productivity tools are desktop-first. That is acceptable.

Rules:

- On tablet/mobile, collapse sidebars into drawers.
- Keep core actions accessible.
- Avoid trying to show full desktop tables on small screens.
- Use cards or stacked rows for mobile data views.
- Keep detail pages readable.
- Preserve keyboard and pointer behavior on desktop.

Do not compromise the desktop experience just to force a mobile-first layout if the product is mainly used on desktop.

## Accessibility

Native-feeling also means accessible.

Checklist:

- All interactive elements have visible focus states.
- Icon-only buttons have labels.
- Status is not communicated by color alone.
- Text contrast is sufficient.
- Menus are keyboard navigable.
- Dialogs trap focus correctly.
- Escape closes transient UI.
- Click targets are large enough even in dense UI.
- Reduced motion is respected.

## Implementation checklist

Before finalizing an app UI, verify:

- The app shell has stable regions.
- Navigation hierarchy is obvious.
- The active item is clearly visible.
- Primary content is not competing with secondary metadata.
- List rows are scannable.
- Detail pages are readable.
- Menus feel native and compact.
- Status, priority, and assignee metadata are consistent.
- Hover, selected, and focused states are distinct.
- Keyboard workflows are supported.
- Empty/loading/error states are designed.
- The app feels usable for several hours of daily work.

## Tailwind direction

Use tokens and reusable primitives. Do not hand-style every row differently.

Suggested primitives:

- `AppShell`
- `Sidebar`
- `SidebarSection`
- `SidebarItem`
- `Topbar`
- `ToolbarButton`
- `IssueRow`
- `ListGroup`
- `InspectorPanel`
- `PropertyRow`
- `Menu`
- `MenuItem`
- `StatusBadge`
- `PriorityIcon`
- `Avatar`
- `CommentInput`

Example sidebar item:

```html
<button class="flex h-8 w-full items-center gap-2 rounded-md px-2 text-sm text-white/60 hover:bg-white/[0.06] hover:text-white data-[active=true]:bg-white/[0.08] data-[active=true]:text-white">
  <span class="size-4 shrink-0 text-white/40">...</span>
  <span class="truncate">Issues</span>
</button>
```

Example issue row:

```html
<button class="group grid h-9 w-full grid-cols-[auto_auto_1fr_auto] items-center gap-3 rounded-md px-3 text-left text-sm hover:bg-white/[0.045] data-[selected=true]:bg-white/[0.07]">
  <span class="size-3 rounded-full border border-white/40"></span>
  <span class="font-mono text-xs text-white/35">DEV-17</span>
  <span class="truncate text-white/82">Portfolio post type</span>
  <span class="text-xs text-white/35">Cycle 102</span>
</button>
```

Example menu:

```html
<div class="w-64 rounded-xl border border-white/10 bg-neutral-900/95 p-1.5 shadow-2xl backdrop-blur">
  <button class="flex h-8 w-full items-center gap-2 rounded-md px-2 text-sm text-white/75 hover:bg-white/[0.06] hover:text-white">
    <span class="size-4"></span>
    <span class="flex-1 text-left">In Progress</span>
    <span class="text-xs text-white/35">3</span>
  </button>
</div>
```

## Quality bar

A successful app UI should feel like a real tool that experienced users can live in. It should be quiet, fast, structured, and precise. The interface should not call attention to itself more than the user’s work.
