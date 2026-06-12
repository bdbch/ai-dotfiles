# fallow reference

Deeper detail for the `fallow` skill. Read this when you need verdict/exit-code
semantics, output formats, gate modes, or you hit a gotcha. All commands run
from the **root of the target project**.

## Verdict & exit codes (`fallow audit`)

By default an audit only **fails** on findings *introduced* by the changeset
(gate `new-only`); inherited findings are reported but don't fail the gate.

| Verdict | Exit | Meaning |
|---------|------|---------|
| `pass`  | 0    | No introduced issues in changed files |
| `warn`  | 0    | Issues found, all warn-severity |
| `fail`  | 1    | Error-severity introduced issue (complexity over threshold, or a dead-code rule configured to error) |

Severity defaults: complexity findings over threshold are **errors** (cyclomatic
20, cognitive 15); duplication is a **warning** unless a threshold is configured;
dead-code severity follows the project's rules config.

## Gate modes

- `--gate new-only` (default) — compare against the base ref, fail only on
  findings introduced by the changeset. Runs analysis twice for attribution
  (each JSON finding gets `introduced: true/false`).
- `--gate all` — strict: fail on **every** finding in the changed files,
  including inherited ones. Skips the attribution pass, so it's also faster.

```bash
git --no-pager diff HEAD | fallow audit --diff-stdin --gate all
```

## Scoping to the working tree vs a base

- **Working tree (unstaged + staged + uncommitted) vs HEAD** — pipe the diff:
  ```bash
  git --no-pager diff HEAD | fallow audit --diff-stdin
  ```
- **Committed changes vs a base ref** — `--changed-since` sets the comparison
  point (it does *not* limit to uncommitted changes):
  ```bash
  fallow audit                       # auto-detect base branch (usually main)
  fallow audit --changed-since main  # explicit ref
  ```

## Output formats

`--format <fmt>` (alias `--output`). Verified-useful ones:

- `human` (default) — readable report.
- `json` — full envelope; top-level `kind` discriminator (`audit` for audits),
  audit envelopes carry `verdict`, `summary`, `attribution`, `dead_code`,
  `duplication`, `complexity`. Pair with `--quiet`.
- `markdown` — tidy report to paste into a PR.
- `compact` — one `issue-type:file:line:symbol` per line; grep-friendly.

Also available: `sarif`, `codeclimate`, `pr-comment-github`, `pr-comment-gitlab`,
`review-github`, `review-gitlab`, `badge`.

```bash
git --no-pager diff HEAD | fallow audit --diff-stdin --format json --quiet
```

Read fields off the envelope with whatever JSON tool is around — e.g.
`... | jq -r '.verdict'` if `jq` is installed, or pipe to `node -e`.

`--ci` is shorthand for `--format sarif --fail-on-issues --quiet`. Note it uses
the default `new-only` gate, so it still exits 0 when the changeset introduced no
new error-severity findings even if the touched files have inherited issues — use
`--gate all` for a hard gate.

## Whole-codebase commands

```bash
fallow health --score --targets   # health score (0-100 + grade) + refactor targets + large functions
fallow --summary                  # full scan (dead-code + dupes + health), counts only
fallow                            # full scan, full detail
fallow dead-code                  # unused files/exports/types/deps + circular deps
fallow dupes                      # copy-paste & structural duplication
```

Duplication tuning lives behind `--dupes-mode {strict,mild,weak,semantic}` and
`--dupes-threshold` / `--dupes-min-tokens` / `--dupes-min-lines`.

## Gotchas

- **Project-level findings bypass the diff scope.** Repo-wide findings like
  *unused dependencies* appear in a scoped audit even though they aren't tied to
  a diff line — so a tiny diff can print a long monorepo-wide "unused
  dependencies" list. That's expected. Use the `attribution` / `introduced`
  field (JSON) to separate new from inherited.
- **Workspace-discovery warnings go to stderr.** On monorepos fallow warns about
  undeclared workspaces / globs matching dirs without `package.json`. Advisory;
  doesn't affect the verdict. `--quiet` silences progress; `2>/dev/null` drops
  them when capturing stdout.
- **Suppress one finding** with `// fallow-ignore-next-line <issue-type>` (e.g.
  `unused-exports`) directly above the flagged line.

## Optional: gate the agent on a clean audit

Install a Claude Code / Codex hook that blocks `git commit` / `git push` until
`fallow audit` passes (run in the target repo):

```bash
fallow hooks install --target agent   # remove with: fallow hooks uninstall --target agent
```

## Discover everything

```bash
fallow --help
fallow audit --help
fallow health --help
```

Online docs: https://docs.fallow.tools/cli/audit.md
