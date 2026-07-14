# Agents

All agents live in `agents/` and are available in opencode. They share a common peer-programming workflow defined in `instructions/README.md` (symlinked as `AGENTS.md` in the opencode config).

## Agent Categories

| Category | Agents |
|----------|--------|
| **Analyze** | [Dead Code](/agents/analyze-dead-code-finder), [Performance](/agents/analyze-performance-investigator), [Regressions](/agents/analyze-regression-hunter), [SEO](/agents/analyze-seo-expert) |
| **Build** | [Angular](/agents/build-framework-angular-developer), [Feature](/agents/build-feature), [Pairprogramming](/agents/build-code-pairprogramming), [React](/agents/build-framework-react-developer), [Refactor](/agents/build-code-refactorer), [Restructure](/agents/build-restructurer), [Rust](/agents/build-rust-developer), [Simplify](/agents/build-code-simplifier), [Solid](/agents/build-framework-solid-developer), [Svelte](/agents/build-framework-svelte-developer), [Tests](/agents/build-code-tests), [Vibe](/agents/build-code-vibe), [Vue](/agents/build-framework-vue-developer) |
| **Explore** | [API Surface](/agents/explore-api-surface-explorer), [Code Map](/agents/explore-code-map), [Code Wiki](/agents/explore-code-wiki), [Codebase](/agents/explore-codebase-explorer), [Data](/agents/explore-data-explorer), [Dependencies](/agents/explore-dependency-explorer), [GitHub](/agents/explore-github-explorer), [Impact](/agents/explore-impact-analyzer) |
| **Plan** | [Architecture](/agents/plan-architecture-planner), [Feature](/agents/plan-feature-planner), [Milestone](/agents/plan-milestone-planner), [Refactor](/agents/plan-refactor-planner), [Release](/agents/plan-release-planner), [Tests](/agents/plan-test-strategist) |
| **Research** | [Dependencies](/agents/research-dependency-upgrade-scout), [Ideas](/agents/research-idea-finder), [Web](/agents/research-web-browser) |
| **Review** | [Accessibility](/agents/review-accessibility-auditor), [API DX](/agents/review-api-dx-reviewer), [Code](/agents/review-code-reviewer), [Design](/agents/review-design-reviewer), [Security](/agents/review-security-reviewer), [TypeScript](/agents/review-typescript-type-reviewer) |
| **Run** | [CLI](/agents/run-terminal-operator), [Git](/agents/run-git-operator), [Support](/agents/run-dev-support) |
| **Research** | [Dependencies](/agents/research-dependency-upgrade-scout), [Ideas](/agents/research-idea-finder), [Web](/agents/research-web-browser) |
| **Review** | [Accessibility](/agents/review-accessibility-auditor), [API DX](/agents/review-api-dx-reviewer), [Code](/agents/review-code-reviewer), [Design](/agents/review-design-reviewer), [Security](/agents/review-security-reviewer), [TypeScript](/agents/review-typescript-type-reviewer) |
| **Test** | [Browser](/agents/test-browser-tester) |
| **Triage** | [Issues](/agents/triage-issue-triage-agent) |
| **Write** | [Changelog](/agents/write-changelog-writer), [Content](/agents/write-content-writer), [Documentation](/agents/write-documentation-writer) |

## All Agents

- [Analyze \| Dead Code](/agents/analyze-dead-code-finder) — Find unused exports, orphaned files, and stale code
- [Analyze \| Performance](/agents/analyze-performance-investigator) — Diagnose load time, jank, and Core Web Vitals
- [Analyze \| Regressions](/agents/analyze-regression-hunter) — Identify ripple effects after bugfixes and refactors
- [Analyze \| SEO](/agents/analyze-seo-expert) — Comprehensive SEO audits and optimization plans
- [Build \| Angular](/agents/build-framework-angular-developer) — Build Angular applications
- [Build \| Feature](/agents/build-feature) — Build features step by step with review after each change
- [Build \| React](/agents/build-framework-react-developer) — Build React applications
- [Build \| Refactor](/agents/build-code-refactorer) — Expert refactoring — improve structure without changing behavior
- [Build \| Restructure](/agents/build-restructurer) — Split large files into focused, well-named modules
- [Build \| Rust](/agents/build-rust-developer) — Write expert Rust code
- [Build \| Simplify](/agents/build-code-simplifier) — Simplify complex code — reduce logic density, clarify intent
- [Build \| Pairprogramming](/agents/build-code-pairprogramming) — Guided pair programming — think and review, never edit
- [Build \| Solid](/agents/build-framework-solid-developer) — Build Solid.js applications
- [Build \| Svelte](/agents/build-framework-svelte-developer) — Build Svelte applications
- [Build \| Vibe](/agents/build-code-vibe) — Build features fast without planning
- [Build \| Tests](/agents/build-code-tests) — Write comprehensive tests at all levels
- [Build \| Vue](/agents/build-framework-vue-developer) — Build Vue.js applications
- [Explore \| API Surface](/agents/explore-api-surface-explorer) — Map all public exports, endpoints, and configuration points
- [Explore \| Code Map](/agents/explore-code-map) — Visual maps of code execution flow
- [Explore \| Code Wiki](/agents/explore-code-wiki) — Wikipedia-style explanations of code symbols
- [Explore \| Codebase](/agents/explore-codebase-explorer) — Map out codebase structure and conventions
- [Explore \| Data](/agents/explore-data-explorer) — Map data models, schemas, API shapes, and state management
- [Explore \| Dependencies](/agents/explore-dependency-explorer) — Analyze the dependency graph — relationships, health, and risks
- [Explore \| GitHub](/agents/explore-github-explorer) — Explore GitHub — issues, PRs, repositories, and code search
- [Explore \| Impact](/agents/explore-impact-analyzer) — Pre-change impact analysis — trace what a change would touch
- [Plan \| Architecture](/agents/plan-architecture-planner) — Design and evaluate architectural decisions
- [Plan \| Feature](/agents/plan-feature-planner) — Plan a feature implementation end-to-end
- [Plan \| Milestone](/agents/plan-milestone-planner) — Plan a milestone — scope, tasks, dependencies, risks
- [Plan \| Refactor](/agents/plan-refactor-planner) — Plan a refactoring effort — scope, strategy, phase breakdown
- [Plan \| Release](/agents/plan-release-planner) — Plan a release — checklist, changelog, validation, cut strategy
- [Plan \| Tests](/agents/plan-test-strategist) — Plan test coverage at unit, integration, and e2e levels
- [Research \| Dependencies](/agents/research-dependency-upgrade-scout) — Investigate dependency-related bugs and plan upgrades
- [Research \| Ideas](/agents/research-idea-finder) — Creative product thinking and feature ideation
- [Research \| Web](/agents/research-web-browser) — Public web research via WebFetch, no local access
- [Review \| Accessibility](/agents/review-accessibility-auditor) — WCAG 2.1 AA compliance audits using Chrome MCP
- [Review \| API DX](/agents/review-api-dx-reviewer) — Public API surface reviews for libraries and modules
- [Review \| Code](/agents/review-code-reviewer) — Structured code reviews with severity levels
- [Review \| Design](/agents/review-design-reviewer) — Comprehensive design review covering visual polish and UX
- [Review \| Security](/agents/review-security-reviewer) — Application security review with JSON output
- [Review \| TypeScript](/agents/review-typescript-type-reviewer) — Review TypeScript types for safety and precision
- [Run \| CLI](/agents/run-terminal-operator) — Execute CLI commands, manage processes, run scripts
- [Run \| Git](/agents/run-git-operator) — Execute git commands, manage branches, commits, and PRs
- [Run \| Support](/agents/run-dev-support) — Support the developer by running development tasks in the terminal
- [Test \| Browser](/agents/test-browser-tester) — Manual end-to-end testing via Chrome MCP
- [Triage \| Issues](/agents/triage-issue-triage-agent) — Classify and prioritize incoming issues
- [Write \| Changelog](/agents/write-changelog-writer) — Generate, format, and maintain changelogs
- [Write \| Content](/agents/write-content-writer) — Write human-facing text and copy
- [Write \| Documentation](/agents/write-documentation-writer) — Produce and improve technical documentation
