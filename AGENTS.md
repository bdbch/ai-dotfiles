![AI DOTFILES COVER](.github/assets/cover.png)

# ai-dotfiles

Personal [opencode](https://opencode.ai) configuration — agents, skills, MCPs, and a peer-programming workflow.

[📖 Read the docs](https://bdbch.github.io/ai-dotfiles/)

## Quick Install

```bash
sh ./installers/opencode.sh
```

This symlinks your opencode config to the repo and installs dependencies:

```
~/.config/opencode/
├── opencode.jsonc      → symlinked
├── opencode.base.json  → symlinked
├── AGENTS.md           → symlinked (instructions/README.md — the coding guidelines hub)
├── instructions/       → symlinked (split conventions: coding, design, docs, etc.)
├── agents/             → symlinked
├── skills/             → symlinked
└── .secrets/           → real dir (tokens stay out of repo)
```

See the [installation guide](https://bdbch.github.io/ai-dotfiles/install/) for full instructions.

## Agents

11 focused agents live in [`agents/*.md`](agents/). Each file has YAML frontmatter with a `description`, `mode`, and `permission` settings.

| Agent | Purpose |
|-------|---------|
| `build-code` | Code writing — vibe mode (fast) or iterative mode (step-by-step) |
| `build-pair` | Read-only pair programming partner |
| `build-mentor` | Coding mentor — guides, explains, never writes code (multilingual) |
| `explore` | Codebase exploration — structure, patterns, code map, data, dependencies |
| `explore-ask` | Q&A coding buddy — answers questions, thinks along |
| `plan` | Feature, architecture, and refactoring planning |
| `plan-milestone` | Milestone and release planning |
| `review-code` | Code review — quality, TypeScript types, API DX |
| `review-security` | Security audit — vulnerabilities, auth, data handling |
| `review-design` | Visual design review — layout, typography, interaction |
| `orchestrator` | Project manager — delegates to agents, tracks progress, reports status |

To add a new agent, create a `.md` file in `agents/` with YAML frontmatter (`description`, `mode`, `permission`).

## Skills

28 skills live in [`skills/*/SKILL.md`](skills/). Agents load skills via `/skill-name` in their instructions to get specialized workflows and knowledge.

### Framework Skills
| Skill | Purpose |
|-------|---------|
| `vue-development` | Vue.js — Composition API, Pinia, FSD, testing |
| `react-development` | React 18/19+ — hooks, RSC, concurrent, testing |
| `godot-development` | Godot 4.x — GDScript, 2D games, signals, physics |
| `angular-development` | Angular 17+ — standalone, signals, RxJS, DI |
| `solid-development` | Solid.js — fine-grained reactivity, signals, stores |
| `svelte-development` | Svelte 5 — runes, SvelteKit, stores, transitions |
| `rust-development` | Rust — ownership, async, error handling, systems |

### Build Skills
| Skill | Purpose |
|-------|---------|
| `creative-ui` | Distinctive UI design — reject templates, find character |
| `refactoring` | Refactor, simplify, restructure code |
| `test-writing` | Write unit, integration, E2E tests |
| `build-workflow` | Iterative vs vibe vs oneshot mode definitions |
| `task-splitter` | Split tasks into small, reviewable subtasks — atomic units of work |

### Explore Skills
| Skill | Purpose |
|-------|---------|
| `code-map` | Trace execution flow with Mermaid diagrams |
| `code-wiki` | Explain symbols in Wikipedia-style articles |
| `data-explorer` | Map data models, schemas, API shapes |
| `dependency-explorer` | Analyze dependency graph, circular deps |
| `api-surface` | Map public exports, endpoints, config |

### Review Skills
| Skill | Purpose |
|-------|---------|
| `accessibility-audit` | WCAG 2.1/2.2 audit — keyboard, screen reader, contrast |
| `design-compliance` | Strict measurable design standards — no opinion |

### Analyze Skills
| Skill | Purpose |
|-------|---------|
| `performance-investigation` | Trace runtime, measure Core Web Vitals |
| `regression-analysis` | Find regressions after changes |
| `dead-code-analysis` | Find unused exports, orphaned files |

### Plan Skills
| Skill | Purpose |
|-------|---------|
| `release-planning` | Release checklist, changelog, rollback |
| `test-strategy` | Plan what to test and at what level |

### Run Skills
| Skill | Purpose |
|-------|---------|
| `git-operations` | Git workflow — Conventional Commits, branches, PRs |
| `terminal-support` | Dev workflow — tests, lint, build, format |

### Write Skills
| Skill | Purpose |
|-------|---------|
| `changelog-writing` | Keep a Changelog, Changesets |
| `technical-writing` | API docs, READMEs, guides |
| `content-writing` | Blog posts, announcements, human-facing copy |

### Research Skills
| Skill | Purpose |
|-------|---------|
| `crazy-ideas` | Blue-sky ideation — wild, unconventional |
| `idea-finder` | Product improvement ideas — grounded in codebase |

### Other Skills
| Skill | Purpose |
|-------|---------|
| `seo-audit` | Technical SEO — meta tags, structured data, CWV |
| `issue-triage` | Classify, prioritize, and route incoming issues |

### Existing Skills (previously created)
| Skill | Purpose |
|-------|---------|
| `accessibility-review` | WCAG audit workflow |
| `browser-debug` | Browser debugging workflow |
| `browser-design-review` | Visual design review workflow |
| `browser-test` | Manual browser testing workflow |
| `code-review` | Code review workflow |
| `github-issue-labeler` | Auto-label GitHub issues |

To add a new skill, create a directory under `skills/` with a `SKILL.md` inside.

## MCP Integrations

Configured in `opencode.base.json`:

| Service | Status | Purpose |
|---------|--------|---------|
| Chrome DevTools | **Always on** | Browser automation for debug, design review, accessibility, testing |
| Linear | Opt-in | Issue tracking, project management |
| GitHub | Opt-in | PR review, issue management |
| Notion | Opt-in | Documentation, knowledge base |

## Workflow Rules

Run the installer after adding new agents or skills — symlinks pick them up automatically. No manual config updates needed.
