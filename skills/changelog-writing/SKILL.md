---
name: "changelog-writing"
description: "Generate changelogs — Keep a Changelog format, Changesets, version bumps, breaking changes."
---

# Changelog Writing

> Generate changelogs — Keep a Changelog format, Changesets, version bumps, breaking changes.

## When to use

Use this skill when you need a changelog generated from commit history, or when writing Changeset files.

## Formats

### Keep a Changelog
```markdown
## [Unreleased]
### Added
- New features.
### Changed
- Changes in existing functionality.
### Fixed
- Bug fixes.
### Security
- Vulnerability fixes.
```

### Changeset file
```markdown
---
'package-name': major | minor | patch
---
Description of the change.
```

## How to write

1. Read the full git log or relevant commit range
2. Categorize entries (Added, Changed, Fixed, etc.)
3. Group related changes under one bullet
4. Rewrite commit messages to user-facing descriptions
5. Flag breaking changes prominently with `[BREAKING]`

## Principles
- Read git log before writing anything
- Group related changes — don't create one entry per commit
- Preserve existing changelog entries
- Don't include every commit — filter chore, ci, style unless consumer-facing
- Don't invent release dates or version numbers
- When writing Changesets: one file per logical change, unique slug filename
