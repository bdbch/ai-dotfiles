---
name: token-efficiency
description: Use when reading code, searching, summarizing, or returning results to another agent. Keeps context windows small and responses compact.
---

# Token Efficiency

> Keep context windows small and responses compact when working with code, docs, or other agents.

## When to use

Use this skill whenever you are:

- Searching a codebase
- Reading a file
- Summarizing findings for another agent
- Calling or responding to a subagent
- Deciding how much context to load

## Search first, read second

1. **Use `grep` or `glob` before `read`**. Find the relevant files and line numbers first.
2. **Read only what you need**. Use the `offset` and `limit` parameters on `read` instead of loading whole files.
3. **Stop early**. If you found the answer in one place, do not keep reading for confirmation unless the caller asked for completeness.
4. **Skip noise**. Ignore generated files, vendored code, lockfiles, build output, and test fixtures unless they are the target.

## Output rules

### For machine-to-machine calls

Output valid JSON when the result is meant for another agent.

Recommended shape:

```json
{
  "answer": "short answer",
  "sources": ["src/foo.ts:42", "src/bar.ts:88"],
  "confidence": "high | medium | low",
  "follow_up_needed": false
}
```

- No prose wrapper around the JSON.
- Omit fields the caller did not ask for.
- Keep snippets under 120 characters.

### For human-facing calls

Use Markdown, but keep it compact:

- Bulleted lists or tables instead of paragraphs.
- One-line summaries.
- `file:line` references so the reader can click or search.
- Avoid repeating what is already in the code.

## Response budgets

Unless the caller asks for detail, aim for:

- **One fact**: 1-3 lines or under 100 tokens.
- **List of items**: up to 10 items.
- **File references only**: no quoted code unless requested.
- **Large files**: read at most 100 lines at a time; summarize before continuing.

## Context management

- **Delegate one concern per subagent**. Do not load unrelated code into the same prompt.
- **Summarize before forwarding**. If a tool returns a large output, compress it before passing it to the next agent.
- **Prefer file:line references over code blocks**. The next agent can read the exact lines if needed.
- **Chunk large tasks**. If a task needs more than a few files, split it and run subagents in parallel.

## Structured extraction

When pulling facts from files:

1. State exactly what you need (function signatures, exported names, dependencies, etc.).
2. Extract only those fields.
3. Return them in the requested structured format.

Example extraction output:

```json
{
  "exports": ["getUser", "postUser"],
  "file": "src/api.ts",
  "framework": "express"
}
```

## What to avoid

- Dumping full file contents into a subagent prompt.
- Repeating the same code in prose.
- Searching broadly when a targeted search would do.
- Returning "I found..." wrappers in machine-to-machine calls.
