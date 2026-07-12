---
name: "pr-creator"
description: "Create a GitHub PR from recent changes using the GH CLI — short, human-readable descriptions, no AI-generated fluff."
---

# PR Creator

> Create a GitHub PR from recent changes using the GH CLI.

## When to use

Use this skill when you want to turn local changes into a GitHub pull request. It uses the `gh` CLI to create the PR and writes the description in short, plain English.

## How it works

1. Check what changed with `git diff`
2. Look for a PR template at `.github/PULL_REQUEST_TEMPLATE.md`
3. Write a short description (no walls of text)
4. Create the PR with `gh pr create`

## Writing the description

**Keep it short.** The goal is to tell someone what you did and why, in 15 seconds or less.

### Title

Use the Conventional Commits format if the project uses it:

```
feat(api): add search endpoint
fix(auth): handle expired tokens
docs(readme): update setup guide
```

If there's no convention, just write what you did in imperative:

```
Add search endpoint
Fix token expiry bug
Update setup guide
```

### Body

Stick to 2-4 short lines. No intro paragraphs, no "this PR implements", no filler.

```
What: Add search by product name and category.
Why: The old search only matched exact IDs, users couldn't find products.

Closes #42
```

**Rules:**

- Start each line with `What:`, `Why:`, or leave plain
- If there's a related issue, always link it with `Closes #N` or `Refs #N`
- No bullet lists longer than 5 items
- No changelog-style categorizations unless the project uses them
- No "checklist" sections, no "testing instructions" — unless the template asks for it

### If there's a PR template

Fill it in, but keep answers short. If a section doesn't apply, write `N/A` instead of deleting it.

## Creating the PR

```bash
gh pr create --title "$TITLE" --body "$BODY"
```

If the PR is a work in progress, mark it as draft:

```bash
gh pr create --draft --title "$TITLE" --body "$BODY"
```

## What to avoid

- **No AI-generated walls of text.** No "This PR implements comprehensive changes across the codebase to enhance..."
- **No buzzwords.** No "seamless", "robust", "cutting-edge", "deep dive".
- **No long lists.** If you have more than 5 changes, group them.
- **No "testing instructions" section** unless the template requires it.
- **No reviewer notes** unless the change needs special attention.
- **No em dashes or fancy punctuation.** Keep it plain.

## Example

```bash
gh pr create --title "fix(api): return 404 for deleted products" \
  --body "What: Products that got soft-deleted were returning 200 with empty data.
Why: The frontend showed blank cards instead of a proper 'not found' state.

Closes #127"
```

## Reference

- [gh pr create docs](https://cli.github.com/manual/gh_pr_create)
- [Conventional Commits](https://www.conventionalcommits.org/)
