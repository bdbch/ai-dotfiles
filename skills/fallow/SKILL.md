---
name: fallow
description: >-
  Audit, health-check, and review TypeScript/JavaScript code with the `fallow`
  CLI — find dead code, unused exports/dependencies, circular deps, code
  duplication, and complexity hotspots. Use when asked to audit/review the
  current changes (unstaged or vs a base branch) or run a whole-codebase health
  check / quality audit on a TS/JS project.
---

# fallow — codebase audits & health checks

`fallow` is a Rust-native static analyzer for TypeScript/JavaScript: unused code,
unused dependencies, circular imports, duplication, complexity hotspots — fast,
zero-config. Drive it by **running its commands directly**. Run everything from
the **root of the target project** (commands are cwd-relative).

Two jobs, two command shapes:

- **Audit a changeset** (`fallow audit`) — scoped to changed files, returns a
  `pass`/`warn`/`fail` verdict. The "did my edits introduce problems?" check —
  use after editing or before a PR.
- **Audit the whole codebase** (`fallow`, `fallow health`) — repo-wide dead code,
  duplication, and a health score.

## Prerequisites

`fallow` must be on `PATH` (or use `npx fallow ...`). No project config or build
step needed:

```bash
command -v fallow || npm install -g fallow
```

## Common commands

**Review the changes you just made** (working tree vs `HEAD`):

```bash
git --no-pager diff HEAD | fallow audit --diff-stdin
```

**Review a branch / PR** against a base (omit ref to auto-detect, usually `main`):

```bash
fallow audit                          # auto-detect base
fallow audit --changed-since main     # explicit base ref
```

**Whole-codebase health & audit:**

```bash
fallow health --score --targets       # health score (0-100 + grade) + refactor targets
fallow --summary                      # full scan (dead-code + dupes + health), counts only
```

Exit code: `fallow audit` exits **1** only on a `fail` verdict (an
error-severity issue *introduced* by the changeset); `pass`/`warn` exit 0.

## When you need more

Read **[reference.md](reference.md)** for:

- Verdict/severity rules and exit codes in full
- Gate modes — `--gate all` (fail on every finding) vs default `new-only`
- Output formats for parsing/PRs — `--format json` (envelope with `verdict`),
  `markdown`, `compact`, `sarif`
- Focused analyses — `fallow dead-code`, `fallow dupes`
- Gotchas (e.g. repo-wide findings appear even in a scoped audit; stderr
  workspace warnings; inline `// fallow-ignore-next-line <type>` suppression)
- Installing the agent commit/push gate, and troubleshooting

Or ask fallow directly: `fallow --help`, `fallow audit --help`,
`fallow health --help`.
