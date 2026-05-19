---
name: "GitHub Issue Labeler"
description: "Finds unlabeled GitHub issues in the current repository, plans appropriate labels based on issue content, and applies them after user confirmation."
---

# GitHub Issue Labeler

> Finds unlabeled GitHub issues in the current repository, plans appropriate labels based on issue content, and applies them after user confirmation.

## When to use

Use this skill when a GitHub repository has open issues that are missing labels and need triage. This skill automates the process of reading unlabeled issues, planning suitable labels from the existing label pool, and applying them after user confirmation.

This is useful for:

- Triage sessions where you want to label a batch of issues quickly.
- Keeping issue trackers organized without manual review of every issue.
- Onboarding labels to a new repository or project.
- Cleaning up a backlog of unlabeled issues.

## How to label issues

Run this workflow in a loop. After the final step, ask the user whether to continue; if yes, restart from step 3 (fetch issues).

1. **Discover the repository** — Run `gh repo view --json nameWithOwner` and extract `owner/repo` from the output. If it fails, parse `git remote get-url origin` instead.

2. **Fetch available labels** — Run `gh label list --json name,description --repo owner/repo` and collect all existing label names and descriptions. This is the pool of valid labels. Do not invent labels that do not exist in this list.

3. **Fetch unlabeled issues** — Run `gh issue list --state open --limit 50 --search 'no:label' --json number,title --repo owner/repo`. If there are no results, report that no unlabeled issues remain and end the workflow.

4. **Read each issue** — For every issue returned, run `gh issue view NUMBER --json title,body,comments,labels --repo owner/repo` to read the full content and any discussion.

5. **Plan labels** — For each issue, analyze the title, body, and comments against the available label pool. Use the Label Planning Rules below to decide the best-fit label. Build a mapping like `#123: bug`, `#456: enhancement`, `#789: question`. If an issue already has labels (race condition from step 3), skip it.

6. **Show the plan and confirm** — Present the mapping to the user as a Markdown table with columns `Issue`, `Title`, `Proposed Label`. Then use the `question` tool with exactly two options:
   - `"Apply All"` — proceed to apply all labels.
   - `"Cancel"` — abort without applying anything.
   Do not add a custom text input option. If the user cancels, end the workflow.

7. **Apply labels** — For each issue in the confirmed plan, run `gh issue edit NUMBER --add-label LABEL --repo owner/repo`.

8. **Ask to continue** — Use the `question` tool with options:
   - `"Continue"` — go back to step 3 (fetch unlabeled issues again; new ones may exist or previously skipped ones may still be unlabeled).
   - `"Stop"` — end the workflow.

## Label Planning Rules

Match each issue to the single most specific label that exists in the repo's label pool. Use these heuristics:

- **bug / type:bug**: Error messages, stack traces, unexpected behavior, crashes, regressions, broken functionality, test failures.
- **enhancement / feature / type:feature**: New feature requests, capability additions, suggestions for new behavior.
- **improvement / enhancement / type:improvement**: Making existing behavior better without adding new features — performance, UX polish, refactoring.
- **documentation / docs / type:docs**: Typos in docs, missing docs, unclear docs, README improvements, comments.
- **question / type:question**: How-to questions, clarification requests, non-actionable inquiries.
- **discussion / type:discussion**: Open-ended conversations, proposals seeking consensus, design debates.
- **good first issue / good first / beginner-friendly**: Simple, well-scoped, and self-contained — suitable for a new contributor.
- **help wanted**: The issue author or maintainer explicitly asks for external help.
- **duplicate**: The issue describes the same problem as another existing issue (check by reading comments for "duplicate of" references).
- **wontfix / wont-fix / wont do**: The maintainer or author has decided not to act — only apply if there is clear consensus in the comments.
- **invalid**: Not a real issue — user error, environment issue, not reproducible. Only apply if confirmed in comments.

When multiple labels could fit, prefer the more specific one (e.g., `bug` over `help wanted`). When no label fits well, skip the issue — do not force a label.

If the repo uses a prefixed naming convention (e.g., `type:bug`, `area:ui`), respect that convention and match using the prefix.

## What to respond

After step 5 (planning), respond with:

**Proposed Labels:**
| Issue | Title | Proposed Label |
|-------|-------|---------------|

After step 7 (applying), respond with:

**Applied Labels:** A summary line like "Applied 4 labels to 4 issues. 1 issue was skipped (no matching label)."

After the user ends the workflow, respond with a final summary: total issues labeled this session.
