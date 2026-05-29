---
name: "Issue Triage"
description: "Triage incoming issues — classify type, assess completeness, determine severity and priority, route to the right team."
---

# Issue Triage

> Triage incoming issues — classify type, assess completeness, determine severity and priority, route to the right team.

## When to use

Use this skill when you need to triage incoming issues from GitHub Issues, Linear, Jira, or any tracker.

## How to triage

1. Read the full issue content including comments and attachments
2. Classify the type
3. Assess completeness
4. Determine severity and priority
5. Identify affected areas
6. Flag missing information

## Classification

### Issue types
- Bug: unexpected behavior
- Feature request: new capability
- Documentation: docs improvement
- Question: user asking for help
- Support: user needs assistance
- Chore: maintenance, tooling

### Severity
- Critical: blocking, data loss, security
- High: major impact, broken functionality
- Medium: limited impact, workaround exists
- Low: cosmetic, nice-to-have

### Priority
- Urgent: fix immediately
- High: next release
- Medium: this sprint
- Low: backlog

### Completeness
- Complete: has repro steps, expected vs actual, environment, screenshots
- Needs minor info: missing one detail
- Needs major info: missing reproduction or context
- Incomplete: cannot act on this

## Output structure

### Classification
Bug, feature request, documentation, question, support, chore.

### Completeness Assessment
Rating and what's missing.

### Severity & Priority
With rationale.

### Affected Areas
Which parts of the codebase the issue relates to.

### Action Items
What needs to happen next.

### Labels Suggested
Type, severity, area labels.

## Principles
- Err on requesting more information if anything is unclear
- Distinguish bug from feature request
- For bugs: can it be reproduced from description alone?
- Consider reporter experience level
- Flag security issues for immediate attention
- Don't dismiss poorly written issues — evaluate the underlying problem
- Don't assign priority based on reporter tone
