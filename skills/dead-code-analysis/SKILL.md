---
name: "dead-code-analysis"
description: "Find dead code — unused exports, orphaned files, unreachable code, stale comments."
---

# Dead Code Analysis

> Find dead code — unused exports, orphaned files, unreachable code, stale comments.

## When to use

Use this skill when you want to find unused exports, orphaned files, unreachable code, or stale comments. Produces a structured report — never deletes anything.

## Scan categories

### 1. Orphaned files
Files that exist but are never imported. Grep for the file's module path across all source files.

### 2. Unused exports
Symbols exported but never imported elsewhere. Find all exports, grep for import sites.

### 3. Unused imports
Imports that are never referenced in the file body. Check each import binding against file usage.

### 4. Unused parameters
Function parameters never referenced in the body. Skip common callback patterns (req, res, next).

### 5. Stale commented-out code
Multi-line comments containing code patterns. 5+ lines = high confidence.

### 6. Unreachable code
Code after return/throw/break/continue without a label or conditional boundary.

### 7. Stale TODOs/FIXMEs
Comments lacking issue reference, author, or date.

## Output format
JSON with:
- `meta`: scanned paths, file count, duration
- `summary`: totals by category, confidence levels
- `findings[]`: category, severity, confidence, file, line, symbol, evidence, deletion_safe
- `quick_deletions[]`: high-severity, high-confidence candidates
- `needs_review[]`: items requiring human judgment

## Confidence levels
- **High**: clearly unused, no side effects — safe to delete
- **Medium**: likely unused, needs confirmation
- **Low**: possible dead code, worth checking during refactor

## Principles
- Prioritize actionable findings over low-confidence guesses
- Distinguish "dead by static analysis" vs "dead by intent"
- Check barrel files separately
- Note when scanning a subset — results are partial
- Skip node_modules, dist, build, .git, coverage
