---
name: "Task Splitter"
description: "Split any task into small, reviewable subtasks — atomic units of work that are easy to track, easy to review, and hard to get wrong."
---

# Task Splitter

> Split any task into small, reviewable subtasks — atomic units of work that are easy to track, easy to review, and hard to get wrong.

## When to use

Use this skill at the start of any non-trivial task. Before writing code, before planning implementation, split the work into small subtasks. Every agent should load this skill when facing a task that touches more than one file or involves more than one logical step.

## Core principle

**Small tasks ship. Big tasks stall.** A 200-line diff is hard to review. A 30-line diff is easy. The goal is to make every change so small that a reviewer can say "yes, this is correct" in under 60 seconds.

## The splitting process

### Step 1: Understand the full scope

Before splitting, answer:

- What is the end state? What must be true when this is done?
- What files/modules/systems are affected?
- What is the simplest path from now to done?

Write one sentence: **"When this is done, [concrete outcome]."**

### Step 2: Identify the natural seams

Every task has natural break points. Find them:

| Seam type | Example |
|-----------|---------|
| **File boundary** | One change per file (or per closely related pair) |
| **Logical boundary** | Types first, then implementation, then tests |
| **Dependency boundary** | Foundation before features that use it |
| **Behavior boundary** | Each user-facing behavior gets its own task |
| **Layer boundary** | Data layer, business logic, presentation — separate tasks |

### Step 3: Split into atomic subtasks

Each subtask must satisfy ALL of these criteria:

1. **One output** — produces exactly one tangible result (a file changed, a function added, a test written)
2. **Self-contained** — can be described and reviewed without reading other subtasks
3. **Independently verifiable** — has a clear "is this done?" check
4. **Small** — ideally 5–50 lines of code changes. Never more than 100.
5. **Named clearly** — the name tells you what changed

**The naming pattern:** `[verb] [what] [where]`

```
Good:  "Add ProductType enum to src/types/product.ts"
Good:  "Create ProductCard component in src/components/"
Good:  "Add price validation to ProductForm submit handler"
Bad:  "Implement product system"
Bad:  "Update types"
Bad:  "Fix stuff"
```

### Step 4: Order by dependency

Arrange subtasks so each one builds on the previous:

```
1. Add types          ← nothing depends on this yet
2. Add utility function  ← uses the types
3. Add component       ← uses the utility function
4. Add tests           ← uses the component
5. Update exports      ← uses everything above
```

**Rule:** If subtask B imports from or calls subtask A's output, A comes first.

### Step 5: Create the task list

Output a numbered checklist. Each item is one subtask:

```markdown
## Task: [original task description]

### Subtasks

- [ ] 1. [verb] [what] [where]
      - Changes: [files affected]
      - Verify: [how to check it's done]

- [ ] 2. [verb] [what] [where]
      - Changes: [files affected]
      - Verify: [how to check it's done]

- [ ] 3. [verb] [what] [where]
      - Changes: [files affected]
      - Verify: [how to check it's done]

### Notes
- [any context, constraints, or decisions worth noting]
```

## Splitting patterns

### Pattern: Foundation → Feature → Polish

For new features:

```
1. Add types/interfaces
2. Add core logic (pure functions, no side effects)
3. Add integration (wire to system)
4. Add UI/presentation
5. Add tests
6. Update exports/barrels
```

### Pattern: One file at a time

For changes across multiple files:

```
1. Update src/types/api.ts — add new response type
2. Update src/services/api.ts — add fetch function
3. Update src/hooks/useData.ts — add hook using fetch
4. Update src/components/DataView.tsx — use hook
5. Update src/pages/DataPage.tsx — render DataView
```

### Pattern: Extract then refactor

For refactoring existing code:

```
1. Extract functionA into its own file (no behavior change)
2. Extract functionB into its own file (no behavior change)
3. Update imports in consumers
4. Remove old combined file
5. Add tests for extracted functions
```

**Key:** Each step is a no-behavior-change refactor until step 5. Easy to review because nothing breaks.

### Pattern: Bug fix

```
1. Add failing test that reproduces the bug
2. Fix the bug (minimal change)
3. Verify test passes
4. Check for similar patterns elsewhere
```

## Splitting anti-patterns

| Anti-pattern | Why it's bad | Fix |
|-------------|-------------|-----|
| **The big bang** | One task that changes 10 files | Split by file or by layer |
| **The hidden dependency** | Task 3 needs Task 5's output | Order by actual dependency |
| **The vague task** | "Improve performance" | Make each subtask a specific measurement + change |
| **The micro-manage** | "Type the letter 'x' on line 42" | Subtasks should be outcomes, not keystrokes |
| **The orphan** | A subtask with no clear verify step | Every subtask needs a check |
| **The coupled pair** | Two subtasks that must be reviewed together | Merge them into one |

## Size guide

| Subtask size | Review time | Verdict |
|-------------|------------|---------|
| 1–10 lines | 10 seconds | Ideal |
| 11–30 lines | 30 seconds | Good |
| 31–50 lines | 1 minute | Acceptable |
| 51–100 lines | 2+ minutes | Split further if possible |
| 100+ lines | 5+ minutes | Must split |

## Review checklist

When reviewing subtasks, check each one:

- [ ] Does the name describe what changed?
- [ ] Can I verify it's done without reading other subtasks?
- [ ] Is it under 100 lines of changes?
- [ ] Does it include the files it touches?
- [ ] Is it in the right order (dependencies satisfied)?

## Output format

For any input task, produce:

```markdown
## Task: [input task]

### Subtasks

- [ ] 1. [name]
      - Files: [list]
      - Verify: [check]

- [ ] 2. [name]
      - Files: [list]
      - Verify: [check]

...

### Total: [N] subtasks, estimated [N × 30 seconds] review time
```

## Combining with other skills

- **Goal Decomposition:** Decomposes the *goal* — Task Splitter decomposes the *implementation*
- **Scope Management:** Protects scope — Task Splitter makes scope visible as subtasks
- **Build Workflow:** Determines how subtasks are executed (iterative = one at a time, vibe = all at once)
- **Test Writing:** Each subtask's verify step can be a test

## Reference

- Atomic Commits — each commit does one thing
- Single Responsibility Principle — each unit has one reason to change
- Independent Deployability — each change can ship alone
- The Boy Scout Rule — leave the code better than you found it, one small change at a time
