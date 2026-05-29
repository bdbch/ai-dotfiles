---
name: "PR Writing"
description: "Write high-quality pull request descriptions — analyze diffs, apply templates, link issues, categorize changes, write changelog entries, and guide reviewers."
---

# PR Writing

> Write high-quality pull request descriptions — analyze diffs, apply templates, link issues, categorize changes, write changelog entries, and guide reviewers.

## When to use

Use this skill when creating or updating a pull request. Before writing, analyze the diff between the current branch and the base branch. Apply project templates if they exist. Write a structured description that explains what, why, and how to review.

## Core principle

**A PR is communication, not just code.** A well-written PR:
- Tells reviewers WHAT changed and WHY
- Highlights what to focus on during review
- Documents decisions made during implementation
- Links to related issues, tickets, or discussions
- Sets up the changelog entry

## PR structure

### Title

Follow Conventional Commits format if the project uses it:

```
type(scope): short description

Examples:
  feat(api): add product search endpoint
  fix(auth): handle expired tokens gracefully
  refactor(cart): extract pricing logic
  docs(readme): update installation instructions
  chore(deps): upgrade lodash to 4.17.21
```

If no convention is specified, use clear imperative English:
```
"Add product search endpoint"  ✓
"Added product search endpoint" ✗ (past tense)
"Adding product search" ✗ (vague)
```

### Description body

```markdown
## Summary
[1-2 sentences describing the change and why it's needed]

## Changes
- **[area]**: [specific change] — [reason if non-obvious]
- **[area]**: [specific change]
- **[area]**: [specific change]

## Related issues
Closes #123
Relates to #456

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manual testing steps:
  1. Run `npm run dev`
  2. Navigate to /search
  3. Type a query → results appear

## Reviewer notes
- Focus on [specific file or area]
- The [X] approach was chosen over [Y] because [reason]

## Checklist
- [ ] Code follows project conventions
- [ ] Tests cover new behavior
- [ ] Existing tests still pass
- [ ] Documentation updated (if applicable)
- [ ] No debug artifacts (console.log, TODOs)
```

## Reading the diff

Before writing the description, analyze the diff to extract:

| What to look for | How to describe it |
|-----------------|-------------------|
| New files | "Added [filename] for [purpose]" |
| Modified files | "Updated [filename] to [behavior change]" |
| Deleted files | "Removed [filename], no longer needed because..." |
| Significant line changes | Focus on logic changes, not formatting/rename |
| Test changes | Note if tests were added, removed, or modified |
| Configuration changes | Call out env vars, CI changes, dependency bumps |

## Template usage

If the project has a PR template (`.github/PULL_REQUEST_TEMPLATE.md`), fill it out completely. Don't delete sections — write "N/A" if a section doesn't apply.

Common template sections:
- Description of changes
- Type of change (feat/fix/docs/refactor/chore)
- How has this been tested?
- Checklist
- Screenshots (for UI changes)
- Additional context

## Changelog categorization

When writing the PR, categorize the change for changelog generation:

| Category | Description | Example |
|----------|-------------|---------|
| `feat` | New feature | New API endpoint, new component |
| `fix` | Bug fix | Corrected behavior, edge case handling |
| `docs` | Documentation | README, API docs, comments |
| `refactor` | Code restructure | Extract method, rename, move files |
| `perf` | Performance | Faster query, reduced bundle size |
| `test` | Testing | New tests, test improvements |
| `chore` | Maintenance | Dependency updates, CI changes |
| `style` | Formatting | Lint fixes, formatting (no logic change) |

## Multiple commits in one PR

If the branch has multiple commits, summarize them:

```
Commits in this PR:
  1. Added search endpoint (feat)
  2. Added input validation (fix)
  3. Added pagination (feat)
  4. Cleaned up debug logging (chore)

Overall: Added search with validation and pagination
```

## Draft vs ready-for-review

- **Draft PR:** Use when the code isn't complete but you want early feedback on approach
- **Ready PR:** Use when code is complete, tested, and ready for full review

In the description, note if it's a draft:

```
⚠️ Draft — Feedback on approach welcome, code not final
```

## Reviewer guidance

Help reviewers help you:

```markdown
## Reviewer notes
- Start with [filename] — it has the core logic
- [specific function] is the most complex part
- I'm unsure about [specific decision] — would appreciate input
- The test in [file] covers the main scenarios
```

## Multi-PR strategy

For large changes, consider splitting into multiple smaller PRs:

**Pattern: Stacked PRs**
```
PR 1: Add database migration (safe, reviewable alone)
PR 2: Add backend API (depends on PR 1)
PR 3: Add frontend UI (depends on PR 2)
```

**Benefits:** Each PR is small, focused, and reviewable independently. Reviewers don't have to hold 500+ lines in their head.

## PR writing anti-patterns

- **Vague titles:** "Update stuff", "Fix things", "Changes"
- **Empty descriptions:** Title only, no context
- **Giant PRs:** 2000+ line changes with no explanation of what's what
- **Missing rationale:** Shows what changed but not why
- **Unlinked issues:** No reference to the ticket or discussion that prompted the change
- **No testing notes:** Reviewer doesn't know how to verify the change works
- **Buried decisions:** Important design decisions hidden in comments or commit messages
- **Checklist left unchecked:** Template checkboxes not filled in

## Reference

- [Conventional Commits](https://www.conventionalcommits.org/)
- GitHub PR templates: `.github/PULL_REQUEST_TEMPLATE.md`
- [Stacked PRs](https://stackoverflow.blog/2022/06/27/a-developers-guide-to-pull-requests-and-code-reviews/)
