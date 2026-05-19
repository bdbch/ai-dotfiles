# GitHub Issue Labeler

Finds unlabeled GitHub issues in the current repository, plans appropriate labels based on issue content, and applies them after user confirmation.

## When to Use

- Triaging a batch of unlabeled issues quickly
- Keeping issue trackers organized without manual review
- Onboarding labels to a new repository or project
- Cleaning up a backlog of unlabeled issues

## Workflow

1. **Discover the repository** — via `gh repo view` or `git remote get-url origin`
2. **Fetch and categorize labels** — groups labels by convention: type, area, priority, status, meta
3. **Fetch unlabeled issues** (up to 50)
4. **Analyze in parallel** — groups issues into batches of 10, launches one subagent per issue to read and plan labels against each category
5. **Collect results** — builds a label plan, filtering out race-conditioned issues
6. **Show plan and confirm** — presents a Markdown table with Issue, Title, and Proposed Labels; asks user to Apply All or Cancel
7. **Apply labels** — for each confirmed issue, runs `gh issue edit` with all matching labels
8. **Ask to continue** — loops back to step 3 or ends

## Label Planning Rules

Labels are categorized by naming convention. Each issue receives labels from every category where a clear match exists.

### Categories

| Category | Convention | Apply |
|---|---|---|
| **Type** | `type:*`, or plain nouns | At most one |
| **Area** | `area:*`, `scope:*`, or domain keywords | Zero or more |
| **Priority** | `priority:*`, `p*`, `sev:*` | At most one |
| **Status** | `status:*`, or lifecycle keywords | At most one |
| **Meta** | No prefix | Zero or more |

### Type heuristics
- **bug / type:bug** — errors, crashes, regressions, broken functionality
- **enhancement / feature / type:feature** — new feature requests
- **improvement / type:improvement** — performance, UX polish, refactoring
- **documentation / docs / type:docs** — typos, missing or unclear docs
- **question / type:question** — how-to questions, clarification requests
- **discussion / type:discussion** — open-ended proposals and design debates

### Area
Apply all area labels that clearly match the issue's subject matter. Skip if uncertain.

### Priority
Only apply when urgency is clear from content:
- **High** — security, data loss, outage, blocking release
- **Medium** — meaningful but not urgent
- **Low** — cosmetic, nice-to-have, edge case

### Status
Check for textual lifecycle signals:
- **Stale** — explicit staleness mentions
- **Needs info** — unanswered follow-up questions
- **Blocked** — blocked by another issue or dependency
- **WIP** — someone is actively working on it

### Meta
- **good first issue** — simple, well-scoped task for new contributors
- **help wanted** — explicit request for external help
- **duplicate** — same problem as another existing issue
- **wontfix** — clear consensus not to act
- **invalid** — user error, not reproducible

When multiple labels fit within a category, prefer the more specific one. Across categories, apply all that clearly match. If none fit, skip.
