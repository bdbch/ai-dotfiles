---
name: "Git Operations"
description: "Git workflow — commits (Conventional Commits), branches, PRs, merge, rebase, conflict resolution."
---

# Git Operations

> Git workflow — commits (Conventional Commits), branches, PRs, merge, rebase, conflict resolution.

## When to use

Use this skill for all git operations: committing, branching, merging, rebasing, resolving conflicts, managing PRs, inspecting history.

## Conventional Commits

Every commit must follow:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types
| Type | Usage |
|------|-------|
| `feat` | New feature |
| `fix` | Bug fix |
| `chore` | Maintenance, tooling, dependency updates |
| `docs` | Documentation only |
| `refactor` | Code change without bug fix or feature |
| `test` | Adding or correcting tests |
| `style` | Formatting, whitespace |
| `perf` | Performance improvement |
| `ci` | CI/CD configuration |
| `build` | Build system or dependencies |
| `revert` | Reverts a previous commit |

### Scopes
Check `SCOPES.md` at project root for valid scopes. If it doesn't exist, create it from the top-level directory structure.

## Workflows

### Creating a commit
1. Review `git status` and `git diff`
2. Read `SCOPES.md` for the best scope
3. Craft commit message in `<type>(<scope>): <description>` format
4. Show the user the proposed message and diff before committing

### Creating a PR
1. Check current branch and diff
2. Suggest PR title and description (Conventional Commits style)
3. Push branch and create PR with `gh`
4. Return the PR URL

### Cleaning up history
1. Show commit log for the branch
2. Suggest which commits to squash, reword, or reorder
3. Walk through interactive rebase step by step

### Recovering from mistakes
1. Check `git reflog` to find lost state
2. Explain what happened and how to recover
3. Walk through recovery steps safely

## Principles
- Always check `git status` and `git log --oneline -10` before any operation
- Never force-push without explicit confirmation
- Always confirm before destructive operations
- Show diff before committing (unless user explicitly says commit all)
- Don't merge or rebase without showing what will happen first
