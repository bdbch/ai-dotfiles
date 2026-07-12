---
name: "github-issue-labeler"
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

2. **Fetch and categorize labels** — Run `gh label list --json name,description --repo owner/repo` and collect all existing label names and descriptions. Then categorize them by naming convention (e.g., `type:*`, `area:*`, `priority:*`, `status:*`) or common keywords. This produces a structured label pool. Do not invent labels that do not exist in this list. Pass the categorized labels to each subagent in step 4.

3. **Fetch unlabeled issues** — Run `gh issue list --state open --limit 50 --search 'no:label' --json number,title --repo owner/repo`. If there are no results, report that no unlabeled issues remain and end the workflow.

4. **Analyze issues in parallel via subagents** — Group the issues into batches of up to 10. For each batch, launch one subagent per issue in a single message using the `task` tool with `subagent_type: "general"`. Each subagent receives a self-contained prompt containing the issue number, the repo owner/repo, the categorized label pool (grouped by type, area, priority, status, meta), and the Label Planning Rules. The subagent runs `gh issue view NUMBER --json title,body,comments,labels --repo owner/repo`, checks whether the issue already has labels (race condition), and returns a comma-separated list of matching label names, or `skip: already labeled`, or `skip: no matching label`. Use the subagent prompt template below.

5. **Collect results and build the plan** — Gather all subagent responses. Remove entries that returned `skip: already labeled` (they were labeled between fetch and analysis). Build a mapping like `#123: bug, priority-high`. Note any issues that returned `skip: no matching label` for the final summary.

    ### Subagent prompt template

    ```
    Analyze GitHub issue #{number} in repo {owner/repo} and propose labels.

    Categorized available labels:
    {labels grouped by category: type, area, priority, status, meta}

    Label Planning Rules:
    {rules text}

    Steps:
    1. Run `gh issue view {number} --json title,body,comments,labels --repo {owner/repo}`
    2. If the issue already has labels, return exactly: "skip: already labeled"
    3. Analyze title, body, and comments against each category in the label pool:
       - Pick at most one type label.
       - Pick zero or more area labels that clearly match.
       - Pick at most one priority label if urgency is clear.
       - Pick at most one status label if lifecycle signals are present.
       - Pick zero or more meta labels that clearly match.
    4. Return exactly the matching label names separated by commas and a space,
       e.g. "bug, area:ui, priority-medium". If no label matches in any category,
       return exactly: "skip: no matching label"
    ```

6. **Show the plan and confirm** — Present the mapping to the user as a Markdown table with columns `Issue`, `Title`, `Proposed Label`. Then use the `question` tool with exactly two options:
   - `"Apply All"` — proceed to apply all labels.
   - `"Cancel"` — abort without applying anything.
   Do not add a custom text input option. If the user cancels, end the workflow.

7. **Apply labels** — For each issue in the confirmed plan, parse the comma-separated label list and run `gh issue edit NUMBER --add-label LABEL1 --add-label LABEL2 ... --repo owner/repo`.

8. **Ask to continue** — Use the `question` tool with options:
   - `"Continue"` — go back to step 3 (fetch unlabeled issues again; new ones may exist or previously skipped ones may still be unlabeled).
   - `"Stop"` — end the workflow.

## Label Planning Rules

Categorize the available labels by naming convention, then for each issue apply labels from every category where a clear match exists. An issue should typically receive at most one label per category (except for `area`, where multiple areas can apply).

### Label Categories

Labels commonly fall into these groups. Use the naming convention (prefix or keyword) to decide which group a label belongs to.

| Category | Convention | Examples | Apply |
|---|---|---|---|
| **Type** | `type:*`, or plain nouns | `type:bug`, `enhancement`, `docs`, `question` | At most one |
| **Area** | `area:*`, `scope:*`, `module:*`, `component:*`, or domain keywords | `area:ui`, `area:api`, `scope:auth`, `frontend` | Zero or more |
| **Priority** | `priority:*`, `p*`, `sev:*`, `severity:*` | `priority:high`, `p1`, `sev:critical` | At most one |
| **Status** | `status:*`, or lifecycle keywords | `status:stale`, `needs-info`, `blocked`, `wip` | At most one |
| **Meta** | No prefix convention | `good first issue`, `help wanted`, `duplicate`, `invalid`, `wontfix` | Zero or more |

If a label does not clearly fit any category, treat it as type.

### Category Rules

#### Type
- **bug / type:bug**: Error messages, stack traces, unexpected behavior, crashes, regressions, broken functionality, test failures.
- **enhancement / feature / type:feature**: New feature requests, capability additions, suggestions for new behavior.
- **improvement / type:improvement**: Making existing behavior better without adding new features — performance, UX polish, refactoring.
- **documentation / docs / type:docs**: Typos in docs, missing docs, unclear docs, README improvements, comments.
- **question / type:question**: How-to questions, clarification requests, non-actionable inquiries.
- **discussion / type:discussion**: Open-ended conversations, proposals seeking consensus, design debates.

#### Area
Analyze the issue title, body, and comments for mentions of specific components, modules, directories, files, or product features. Match against available area labels (exact names or `area:*` / `scope:*` prefixes). Apply all areas that are clearly relevant. When in doubt about an area, skip it rather than guessing.

#### Priority
Only apply a priority label if the issue content strongly indicates urgency:
- **High / critical / p0-p1**: Security vulnerability, data loss, production outage, crash affecting many users, regression blocking a release.
- **Medium / p2**: Meaningful bug or feature that is not time-sensitive.
- **Low / p3+**: Cosmetic, nice-to-have, edge case, minor improvement.

When the issue does not clearly signal urgency, skip priority — do not default to low.

#### Status
Check the issue's comments, author tone, and metadata for lifecycle signals:
- **Stale**: Only apply if there is an explicit mention of staleness (e.g., a stale bot comment, the author says "this is old", a comment says "still relevant?").
- **Needs more info / needs-info**: The author or a commenter asks a follow-up question that remains unanswered. Look for phrases like "can you provide", "what version", "reproduction steps".
- **Blocked**: The issue explicitly mentions being blocked by another issue, PR, or external dependency.
- **WIP / in-progress**: Someone in the comments says they are working on it or has assigned themselves.

Do not infer status from dates alone — look for textual signals.

#### Meta
- **good first issue / beginner-friendly**: Simple, well-scoped, self-contained task suitable for a new contributor with clear reproduction steps or expected output.
- **help wanted**: The issue author or maintainer explicitly asks for external help.
- **duplicate**: The issue describes the same problem as another existing issue — look for "duplicate of" references in comments.
- **wontfix / wont do**: The maintainer or author has decided not to act — only apply if there is clear consensus in the comments.
- **invalid**: Not a real issue — user error, environment issue, not reproducible. Only apply if confirmed in comments.

### Resolution

When multiple labels fit within the same category, prefer the more specific one (e.g., `bug` over `enhancement` — an issue cannot be both). Across categories, apply all that clearly match. Avoid labels that are a weak or speculative fit. When no label fits well within a category, skip it — do not force a label.

## What to respond

After step 5 (planning), respond with:

**Proposed Labels:**
| Issue | Title | Proposed Label |
|-------|-------|---------------|

After step 7 (applying), respond with:

**Applied Labels:** A summary line like "Applied 7 labels across 4 issues. 1 issue was skipped (no matching label)."

After the user ends the workflow, respond with a final summary: total issues labeled this session.
