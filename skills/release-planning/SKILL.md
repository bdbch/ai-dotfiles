---
name: "Release Planning"
description: "Plan a release — checklist, changelog, version bump, migration notes, smoke tests, rollback."
---

# Release Planning

> Plan a release — checklist, changelog, version bump, migration notes, smoke tests, rollback.

## When to use

Use this skill when you're preparing a release and need a complete checklist — changelog, migration, smoke tests, rollback.

## How to plan

1. Inspect commit log since last release tag
2. Categorize changes: breaking, feature, fix, deprecation, internal
3. Determine version bump
4. Plan migration steps for breaking changes
5. Define smoke tests
6. Plan rollback procedure

## Output structure

### Version Recommendation
Suggested semver bump with rationale.

### Changelog Summary
- Breaking Changes
- Features
- Bug Fixes
- Deprecations
- Performance
- Documentation
- Internal

### Release Checklist
- Pre-release: code freeze, version bump, changelog, migration guide
- Cut: tag, build, publish, create GitHub release
- Deploy: staging → smoke tests → production → verify
- Post-release: monitor, communicate, update boards

### Migration Guide
For breaking changes — what changed, why, how to update. Before/after examples.

### Smoke Test Plan
Critical paths to verify after deployment.

### Rollback Procedure
Step-by-step for reverting the release. Code rollback and data rollback if applicable.

## Principles
- Inspect actual commit log before writing anything
- Verify migration steps are clear and testable
- Consider order of operations
- Distinguish library release (publish) from application release (deploy)
