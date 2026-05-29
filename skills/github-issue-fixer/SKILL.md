---
name: "GitHub Issue Fixer"
description: "Use the gh CLI to fetch issues, discussions, and linked issues — analyze the problem, find relevant code, and implement a fix with a PR."
---

# GitHub Issue Fixer

> Use the gh CLI to fetch issues, discussions, and linked issues — analyze the problem, find relevant code, and implement a fix with a PR.

## When to use

Use this skill when assigned a GitHub issue to fix. The workflow: fetch the issue and all its context (comments, linked issues, source issues), understand the problem thoroughly, locate the relevant code, implement the fix, and create a PR.

## Core principle

**An issue is not fully understood until you've read all its context.** The title and body are rarely enough — comments often reveal edge cases, failed attempts, and the real constraints. Linked issues show related context, and source/dependency issues explain why things are the way they are.

## The issue fixing workflow

```
┌──────────────────────────────────────────────┐
│  1. FETCH CONTEXT                            │
│     issue body, comments, linked issues,     │
│     discussions, cross-references            │
└────────────────────┬─────────────────────────┘
                     ▼
┌──────────────────────────────────────────────┐
│  2. ANALYZE                                  │
│     reproduce locally, understand the root   │
│     cause, identify the failing path         │
└────────────────────┬─────────────────────────┘
                     ▼
┌──────────────────────────────────────────────┐
│  3. PLAN THE FIX                             │
│     narrow to relevant code, design change,  │
│     consider edge cases, check tests         │
└────────────────────┬─────────────────────────┘
                     ▼
┌──────────────────────────────────────────────┐
│  4. IMPLEMENT                                │
│     write code, add/update tests,            │
│     verify fix, check regressions            │
└────────────────────┬─────────────────────────┘
                     ▼
┌──────────────────────────────────────────────┐
│  5. CREATE PR                                │
│     branch, commit, PR description that      │
│     links back to the issue                  │
└──────────────────────────────────────────────┘
```

## Step 1: Fetch context

### Get the issue

```bash
# View issue body and status
gh issue view 123 --repo owner/repo

# Get the full issue including body, state, labels, assignees, milestone
gh issue view 123 --repo owner/repo --json body,title,state,labels,assignees,milestone,comments,reactions

# Get all comments (paginate if needed)
gh issue view 123 --repo owner/repo --comments

# Get the issue in a machine-readable format
gh issue view 123 --repo owner/repo --json number,title,body,state,labels,assignees,comments,url,milestone,projectItems,timelineItems
```

### Find linked issues

```bash
# Search for cross-references in the issue body and comments
# Look for patterns like: #456, closes #456, fixes #456, relates to #456
# Also look in the GitHub UI for "Linked issues" section

# Check if there's a "related to" section in the issue
# Search commits and PRs that mention this issue number
gh search prs "closes #123" --repo owner/repo
gh search commits "#123" --repo owner/repo
```

### Check discussions

```bash
# Search discussions mentioning the issue number
gh discussion list --repo owner/repo --search "#123"

# If a discussion URL is referenced in the issue, fetch it
gh discussion view 456 --repo owner/repo
```

### Check the issue timeline (events, cross-references)

```bash
# Get timeline events (cross-references, state changes, assignments)
gh api repos/owner/repo/issues/123/timeline --paginate

# Look for "cross-referenced" events — these link PRs and other issues
```

### Build the context map

After fetching, organize the context:

```
Issue #123: "Checkout fails with discount code"
──────────────────────────────────────────────
Body: User reports 500 error when applying promo code at checkout

Comments:
  - User: Error only happens with percentage discounts
  - Dev: Confirmed reproducible on staging
  - PM: This is blocking the marketing campaign launch

Linked issues:
  - #120 (source): "Add percentage discount support" (completed, merged 2 days ago)
  - #125 (related): "Discount calculation inaccurate for free shipping"

Cross-referenced PRs:
  - #121 (merged): "Add percentage discount logic" — the likely culprit

Discussion: none
```

## Step 2: Analyze the issue

### Reproduce the problem

```bash
# Get the current branch and repo state
gh repo view owner/repo
git branch -a
git log --oneline -10

# If the issue mentions a specific version/environment, check it
git log --all --oneline | grep "discount\|coupon\|promo"

# Reproduce locally — run the tests, check the behavior
# If it's a bug: follow the reproduction steps in the issue
# If it's a feature: understand the desired behavior
```

### Identify the root cause

Compare the expected behavior with the actual behavior:

- **For bugs:** What changed between "last working" and "now broken"? Check recent commits to the relevant area.
- **For features:** What needs to exist that doesn't yet? Check if there's a partial implementation already.
- **For regressions:** Which PR introduced the regression? `git bisect` can help.

```bash
# Find the commit that introduced a bug (binary search)
git bisect start
git bisect bad HEAD
git bisect good <last-known-working-commit>
# Then mark each commit as good or bad until the culprit is found
git bisect reset

# Check what changed in a specific area
git log --oneline --all -- src/features/discount/
```

### Check existing tests

```bash
# Find related tests
find . -name "*discount*" -o -name "*coupon*" -o -name "*promo*"
grep -r "discount\|coupon" tests/ --include="*.test.*" -l

# Run them to establish a baseline
npm test -- --grep "discount"
# or
go test ./... -run "Discount"
```

## Step 3: Plan the fix

### Define the fix scope

```markdown
## Fix plan for issue #123

### Problem
Percentage discounts cause a 500 error at checkout because
the discount calculation divides by zero when the subtotal
is 0 (free item + percentage discount edge case).

### Root cause
PR #121 added percentage discount support but didn't handle
the case where `subtotal = 0`. The calculation is in
`src/features/discount/calculator.ts:42`.

### Fix
Add a guard in `calculatePercentageDiscount()`:
if subtotal is 0, return 0 instead of dividing.

### Edge cases
- [ ] Subtotal = 0 (the bug)
- [ ] Subtotal = 0 with multiple items
- [ ] Percentage with max discount cap
- [ ] Combined fixed + percentage discounts

### Tests
- [ ] Add test for subtotal = 0 case
- [ ] Verify existing discount tests still pass
- [ ] Verify checkout integration tests pass
```

### Verify against existing usage

```bash
# Check if the function is called from other places
grep -r "calculatePercentageDiscount" src/ --include="*.ts"

# Check for similar patterns that might have the same bug
grep -r "subtotal.*\/" src/ --include="*.ts"
```

## Step 4: Implement

### Branch and implement

```bash
# Create a branch named after the issue
git checkout -b fix/issue-123-discount-divide-by-zero

# Or follow the project's naming convention
# fix/123-discount-zero-subtotal
# fix-123-discount-calculation
```

### Write the fix

Implement the smallest change that resolves the issue. Follow the [iterative-refinement](../iterative-refinement/SKILL.md) cycle:

1. **Draft:** A working fix (happy path)
2. **Review:** Check edge cases, error handling
3. **Refine:** Polish, address feedback
4. **Finalize:** Remove debug artifacts, verify

### Add or update tests

```bash
# Run the specific test to confirm the fix
npm test -- --grep "discount calculation"

# Run the full test suite to check for regressions
npm test

# If the project has it, run integration/E2E tests too
npm run test:e2e
```

### Verify manually if possible

```bash
# Start the dev server
npm run dev
# Follow the reproduction steps from the issue to confirm the fix
```

## Step 5: Create a PR

### Commit

```bash
git add .
git commit -m "fix(checkout): handle zero subtotal in percentage discount

Fixes divide-by-zero error when applying a percentage discount
to a cart with zero subtotal.

Fixes #123"
```

### Push and create PR

```bash
git push origin fix/issue-123-discount-divide-by-zero

# Create PR with full context
gh pr create \
  --repo owner/repo \
  --title "fix(checkout): handle zero subtotal in percentage discount" \
  --body "## Summary
Fixes a divide-by-zero error when applying a percentage discount
to a cart with zero subtotal.

## Changes
- Added guard in \`calculatePercentageDiscount()\` for subtotal = 0
- Added test coverage for the edge case

## Testing
- [x] Unit tests pass
- [x] Manual reproduction no longer errors
- [x] Existing discount integration tests pass

Fixes #123" \
  --label bug
```

### PR description should include

```
- What the issue was (1-2 sentences)
- Root cause (what was wrong)
- What the fix does (the change)
- How to verify (tests run, manual steps)
- Link: "Fixes #123" (auto-closes the issue on merge)
```

## Fetching context: CLI reference

```bash
# Issue details
gh issue view <number> --repo <owner/repo>
gh issue view <number> --repo <owner/repo> --comments
gh issue view <number> --repo <owner/repo> --json body,comments,labels,assignees

# Search
gh search issues "<query>" --repo <owner/repo>
gh search prs "<query>" --repo <owner/repo>

# PR details (for cross-referenced PRs)
gh pr view <number> --repo <owner/repo>
gh pr view <number> --repo <owner/repo> --json body,additions,deletions,files,commits

# API (for anything not covered by gh subcommands)
gh api repos/<owner>/<repo>/issues/<number>/timeline --paginate

# Repo info
gh repo view <owner/repo>
gh repo view <owner/repo> --json defaultBranch,description,homepageUrl
```

## Common issue types and their fix patterns

| Issue type | What to look for | Fix pattern |
|-----------|-----------------|-------------|
| Bug | Reproduction steps, error messages, recent changes to the area | `git bisect`, find the regression, revert or patch |
| Feature request | Desired behavior, acceptance criteria, related issues | Implement per spec, add tests, new PR |
| Performance problem | Profiling output, slow queries, specific bottlenecks | Profile first, optimize hot path, add perf test |
| Regression | "This used to work", recent deploy | Find the PR, check what changed, add regression test |
| Security issue | CVE, vulnerability report, exploit path | Patch immediately, add security test, backport |
| Documentation gap | "How do I...", unclear behavior | Update docs, add example, link to source |

## When to ask for clarification

Before jumping into implementation, check if you need more info:

- **Reproduction steps missing?** Ask for them. Can't fix what you can't reproduce.
- **Edge cases unclear?** List your assumptions and ask for confirmation.
- **Previous attempts mentioned?** Read them carefully to avoid repeating failed approaches.
- **No linked issues?** Search the repo for related issues yourself.

## Pitfalls & gotchas

- **Don't fix only the symptom:** "Added check for null" without understanding *why* it's null often leads to the next bug. Find the root cause.
- **Don't skip the existing tests:** Run them before and after. If they break, your fix has a side effect.
- **Don't assume the issue body is complete:** Always read the comments. The real problem is often in the discussion thread.
- **Don't forget cross-references:** An issue might be part of a milestone or epic. Fixing it in isolation might not be enough.
- **Don't skip reproduction:** "I think it's this" is not a diagnosis. Reproduce the issue to confirm your understanding.
- **Don't create a giant PR:** If the fix touches many files, consider if it could be split. A focused fix is easier to review and less likely to break things.
- **Don't ignore the linked source issue:** If the issue says "caused by #120", read #120. The fix might need changes in both places.

## Reference

- [gh CLI manual](https://cli.github.com/manual/)
- [GitHub Issue format](https://docs.github.com/en/issues/tracking-your-work-with-issues)
- [Conventional Commits](https://www.conventionalcommits.org/) for commit messages
- [Git bisect](https://git-scm.com/docs/git-bisect) for finding regressions
