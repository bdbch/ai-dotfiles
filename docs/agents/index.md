# Agents

All agents live in `agents/` and are available in opencode. They share a common peer-programming workflow defined in `instructions/README.md` (symlinked as `AGENTS.md` in the opencode config).

## Agent Categories

| Category | Agents |
|----------|--------|
| **Analyze** | [Dead Code](/agents/dead-code-finder), [Performance](/agents/performance-investigator), [Regressions](/agents/regression-hunter), [SEO](/agents/seo-expert) |
| **Build** | [Angular](/agents/framework-angular-developer), [Paired](/agents/peer-programmer), [React](/agents/framework-react-developer), [Refactor](/agents/code-refactorer), [Restructure](/agents/restructurer), [Rust](/agents/rust-developer), [Simplify](/agents/code-simplifier), [Slow](/agents/slow-coder), [Solid](/agents/framework-solid-developer), [Svelte](/agents/framework-svelte-developer), [Vibe](/agents/vibe), [Vue](/agents/framework-vue-developer) |
| **Explore** | [API Surface](/agents/api-surface-explorer), [Code Map](/agents/code-map), [Code Wiki](/agents/code-wiki), [Codebase](/agents/codebase-explorer), [Data](/agents/data-explorer), [Dependencies](/agents/dependency-explorer), [GitHub](/agents/github-explorer), [Impact](/agents/impact-analyzer) |
| **Plan** | [Architecture](/agents/architecture-planner), [Feature](/agents/feature-planner), [Milestone](/agents/milestone-planner), [Refactor](/agents/refactor-planner), [Release](/agents/release-planner), [Tests](/agents/test-strategist) |
| **Research** | [Dependencies](/agents/dependency-upgrade-scout), [Ideas](/agents/idea-finder), [Web](/agents/web-browser) |
| **Review** | [Accessibility](/agents/accessibility-auditor), [API DX](/agents/api-dx-reviewer), [Code](/agents/code-reviewer), [Design](/agents/design-reviewer), [Security](/agents/security-reviewer), [TypeScript](/agents/typescript-type-reviewer) |
| **Run** | [CLI](/agents/terminal-operator), [Git](/agents/git-operator), [Support](/agents/dev-support) |
| **Research** | [Dependencies](/agents/dependency-upgrade-scout), [Ideas](/agents/idea-finder), [Web](/agents/web-browser) |
| **Review** | [Accessibility](/agents/accessibility-auditor), [API DX](/agents/api-dx-reviewer), [Code](/agents/code-reviewer), [Design](/agents/design-reviewer), [Security](/agents/security-reviewer), [TypeScript](/agents/typescript-type-reviewer) |
| **Test** | [Browser](/agents/browser-tester) |
| **Triage** | [Issues](/agents/issue-triage-agent) |
| **Write** | [Changelog](/agents/changelog-writer), [Content](/agents/content-writer), [Documentation](/agents/documentation-writer) |

## All Agents

- [Analyze \| Dead Code](/agents/dead-code-finder) — Find unused exports, orphaned files, and stale code
- [Analyze \| Performance](/agents/performance-investigator) — Diagnose load time, jank, and Core Web Vitals
- [Analyze \| Regressions](/agents/regression-hunter) — Identify ripple effects after bugfixes and refactors
- [Analyze \| SEO](/agents/seo-expert) — Comprehensive SEO audits and optimization plans
- [Build \| Angular](/agents/framework-angular-developer) — Build Angular applications
- [Build \| Paired](/agents/peer-programmer) — One-step-at-a-time pair programming
- [Build \| React](/agents/framework-react-developer) — Build React applications
- [Build \| Refactor](/agents/code-refactorer) — Expert refactoring — improve structure without changing behavior
- [Build \| Restructure](/agents/restructurer) — Split large files into focused, well-named modules
- [Build \| Rust](/agents/rust-developer) — Write expert Rust code
- [Build \| Simplify](/agents/code-simplifier) — Simplify complex code — reduce logic density, clarify intent
- [Build \| Slow](/agents/slow-coder) — Slow, deliberate coding with conversation between steps
- [Build \| Solid](/agents/framework-solid-developer) — Build Solid.js applications
- [Build \| Svelte](/agents/framework-svelte-developer) — Build Svelte applications
- [Build \| Vibe](/agents/vibe) — Fast-mode implementation with continuous changes
- [Build \| Vue](/agents/framework-vue-developer) — Build Vue.js applications
- [Explore \| API Surface](/agents/api-surface-explorer) — Map all public exports, endpoints, and configuration points
- [Explore \| Code Map](/agents/code-map) — Visual maps of code execution flow
- [Explore \| Code Wiki](/agents/code-wiki) — Wikipedia-style explanations of code symbols
- [Explore \| Codebase](/agents/codebase-explorer) — Map out codebase structure and conventions
- [Explore \| Data](/agents/data-explorer) — Map data models, schemas, API shapes, and state management
- [Explore \| Dependencies](/agents/dependency-explorer) — Analyze the dependency graph — relationships, health, and risks
- [Explore \| GitHub](/agents/github-explorer) — Explore GitHub — issues, PRs, repositories, and code search
- [Explore \| Impact](/agents/impact-analyzer) — Pre-change impact analysis — trace what a change would touch
- [Plan \| Architecture](/agents/architecture-planner) — Design and evaluate architectural decisions
- [Plan \| Feature](/agents/feature-planner) — Plan a feature implementation end-to-end
- [Plan \| Milestone](/agents/milestone-planner) — Plan a milestone — scope, tasks, dependencies, risks
- [Plan \| Refactor](/agents/refactor-planner) — Plan a refactoring effort — scope, strategy, phase breakdown
- [Plan \| Release](/agents/release-planner) — Plan a release — checklist, changelog, validation, cut strategy
- [Plan \| Tests](/agents/test-strategist) — Plan test coverage at unit, integration, and e2e levels
- [Research \| Dependencies](/agents/dependency-upgrade-scout) — Investigate dependency-related bugs and plan upgrades
- [Research \| Ideas](/agents/idea-finder) — Creative product thinking and feature ideation
- [Research \| Web](/agents/web-browser) — Public web research via WebFetch, no local access
- [Review \| Accessibility](/agents/accessibility-auditor) — WCAG 2.1 AA compliance audits using Chrome MCP
- [Review \| API DX](/agents/api-dx-reviewer) — Public API surface reviews for libraries and modules
- [Review \| Code](/agents/code-reviewer) — Structured code reviews with severity levels
- [Review \| Design](/agents/design-reviewer) — Comprehensive design review covering visual polish and UX
- [Review \| Security](/agents/security-reviewer) — Application security review with JSON output
- [Review \| TypeScript](/agents/typescript-type-reviewer) — Review TypeScript types for safety and precision
- [Run \| CLI](/agents/terminal-operator) — Execute CLI commands, manage processes, run scripts
- [Run \| Git](/agents/git-operator) — Execute git commands, manage branches, commits, and PRs
- [Run \| Support](/agents/dev-support) — Support the developer by running development tasks in the terminal
- [Test \| Browser](/agents/browser-tester) — Manual end-to-end testing via Chrome MCP
- [Triage \| Issues](/agents/issue-triage-agent) — Classify and prioritize incoming issues
- [Write \| Changelog](/agents/changelog-writer) — Generate, format, and maintain changelogs
- [Write \| Content](/agents/content-writer) — Write human-facing text and copy
- [Write \| Documentation](/agents/documentation-writer) — Produce and improve technical documentation
