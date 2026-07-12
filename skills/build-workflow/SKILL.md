---
name: "build-workflow"
description: "Define how code gets built — iterative (step-by-step with review) vs. vibe (fast, automatic) vs. oneshot (single pass)."
---

# Build Workflow

> Define how code gets built — iterative (step-by-step with review) vs. vibe (fast, automatic) vs. oneshot (single pass).

## When to use

Use this skill to define the workflow mode for code changes. Load this skill into a build agent to determine how it should operate.

## Workflow modes

### Iterative (step-by-step with review)
The agent proposes one change at a time, waits for approval, then executes. After each change, it reports what was done and pauses.

1. Understand the task
2. Propose the next change
3. Wait for approval
4. Execute the change
5. Report what changed, why, and what's next
6. Pause and wait for confirmation

**When to use**: Complex changes, production code, unfamiliar codebases, when learning.

### Vibe (fast, automatic)
The agent executes all changes without stopping between steps. No approval gates. Reports everything after completion.

1. Understand the task (one clarifying question at most)
2. Read relevant code
3. Implement all changes in one pass
4. Report what was done, why, and how to verify

**When to use**: Low-risk changes, personal projects, when you trust the agent.

### Oneshot (single pass)
The agent makes one focused change and stops. No continuation, no multi-step work.

1. Read the task
2. Make one focused change
3. Report and stop

**When to use**: Small, well-defined tasks. Bug fixes. Single-file changes.

## Mode selection

| Scenario | Recommended mode |
|----------|-----------------|
| Complex feature in production | Iterative |
| Quick bug fix | Oneshot |
| Personal side project | Vibe |
| Unfamiliar codebase | Iterative |
| Single function change | Oneshot |
| Large refactoring | Iterative |
| Prototype / exploration | Vibe |
