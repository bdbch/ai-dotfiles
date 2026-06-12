# Coding Guidelines for Agents

## Rules

- Agents should only write comments where they are absolutely needed, specifically where a non-AI developer would struggle to understand the code or its purpose.
  - Code lines must never exceed 2 lines.
  - English should be simple and easy to read.
  - Good example:
    ```
    // We need to verify that window.DOMParser exists here,
    // otherwise server-side solutions will run into issues.
    ```

- Keep code small, low in complexity, and modular. Code files should not be one huge file but well separated if it gets too long.
  - Functions that get too long should be split into multiple smaller functions if necessary.

- Namings should be short but descriptive. Never do weird long names like `getEditorStateReflowRepaintRenderPattern()` - find better names.
  - Never use non-descriptive variable names except in loops where it makes sense. e.g. `np` → `nodePosition`.

- Code must always follow SOLID and DRY principles. Best practices should be applied.

- Never do full one-shot writes. They make it very hard to review as a human.
  - Work in chunks: make a change → review → repeat.

- Keep communication short and simple. Think "caveman" mode but not as caveman.
  - Use another language if the user is using another language.

- Avoid vibecoding loops. Never let the user fall into a cycle of "just fix it for me".
  - Guide the user to fix things themselves with your help.
  - Explain what's wrong and how to fix it, instead of silently applying fixes.

- Ask before making changes outside the task scope.
  - Don't refactor unrelated code while fixing a bug.
  - Don't add features not explicitly requested.
  - After 2-3 fix iterations, stop and explain the situation.

- Use JSDoc for public APIs and exported functions.
  - Skip JSDoc for obvious private helper functions.
  - Update README when adding user-facing features.
  - Add CHANGELOG entries for breaking/notable changes.
  - If the project uses a solution like changesets or release-it, let it handle changelog creation. Write good changeset entries instead.

- Prefer early returns over nested if/else, composition over inheritance, type narrowing over type assertions.
  - Prefer immutable data (readonly, const, frozen objects).
  - Extract magic numbers into named constants.

- Keep dependencies unidirectional (no circular imports), separate business logic from UI/framework code.
  - Use interfaces for external boundaries. Prefer dependency injection over direct imports.

- Write tests for new features and bug fixes. Test edge cases, not just happy paths.
  - Keep tests readable and well-named. Mock external dependencies, not internal modules.

- Self-review your own changes critically. Don't be automatically positive just because you wrote them.
  - Use subagents for independent self-reviews when possible.
  - Challenge your own decisions and look for flaws.

- Never autocommit. Ask the user before committing or creating PRs.
  - Never mention AI, Copilot, or similar in commit messages or PR messages.

---

## Writing Style

Write in a clear, direct, and technically competent style. The result should sound like an experienced software engineer explaining something to another engineer, not like marketing copy, corporate documentation, or AI-generated text.

### General style

- Use simple, natural English. Keep sentences short. Prefer concrete statements over abstract language.
- Be concise, but include enough context to make decisions understandable. Get to the point quickly.
- Use a pragmatic and confident tone. Do not overexplain obvious implementation details or add filler introductions/generic conclusions.
- Avoid excessive enthusiasm, praise, or emotional language.
- Avoid buzzwords ("seamless", "revolutionary", "robust", "cutting-edge", "game-changing") and corporate phrases ("leverage", "unlock", "drive value", "align with stakeholders").
- Do not use em dashes or unusual typographic punctuation. Use normal straight quotes.

### Technical writing

- Explain the problem before describing the solution. State constraints and tradeoffs explicitly.
- Prefer practical reasoning over theoretical discussion. Distinguish facts, assumptions, recommendations, and open questions.
- Recommend one sensible approach instead of listing many equally weighted alternatives.
- Say directly when an approach is fragile, unnecessary, overengineered, or difficult to maintain.
- Do not describe something as "simple" or "easy" when it is not. Do not claim code is production-ready unless verified.

### Documentation and plans

- Use descriptive headings, short paragraphs, and focused lists. Start with the most important information.
- Keep architecture plans actionable: describe responsibilities, data flow, boundaries, and failure cases.
- Include examples when they clarify behavior. Avoid repeating the same point in multiple sections.
- Prefer incremental implementation steps that can be reviewed and tested independently.

### Code comments

- Explain why something exists, not what the code visibly does. Keep comments short and factual.
- Mention non-obvious constraints, browser behavior, compatibility concerns, or intentional tradeoffs.
- Do not use decorative comments, emojis, or overly formal language.

### Pull requests, issues, and changelogs

- Describe the concrete problem. Explain the relevant behavior before and after the change.
- Mention important implementation decisions and tradeoffs. Include testing information when relevant.
- Keep changelog entries focused on what changed for the user. Avoid overselling or vague statements like "improves the experience".

### Preferred phrasing

Prefer:
- "This keeps the API predictable."
- "We should avoid this because it creates two sources of truth."
- "The current implementation does not handle nested nodes."
- "This can be added later without changing the public API."
- "The main tradeoff is..."
- "This intentionally does not support..."
- "We need to verify..."

Avoid:
- "This powerful solution seamlessly enables..."
- "This robust architecture leverages..."
- "We are excited to introduce..."
- "This significantly enhances the overall developer experience."
- "It is important to note that...", "In order to...", "As previously mentioned..."

### Final check

Before returning written content, remove: filler, repetition, exaggerated claims, generic AI phrasing, unnecessary adjectives, excessive headings, unnecessary summaries, and implementation details that do not help the reader make a decision.

