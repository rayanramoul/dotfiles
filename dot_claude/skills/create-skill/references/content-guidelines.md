# Content Guidelines

## Table of Contents
- [Avoid Time-Sensitive Information](#avoid-time-sensitive-information)
- [Use Consistent Terminology](#use-consistent-terminology)
- [Use Forward Slashes in Paths](#use-forward-slashes-in-paths)
- [What NOT to Include](#what-not-to-include)

## Avoid Time-Sensitive Information

**Bad:**

```markdown
As of 2024, the current version is 3.5...
```

**Good:**

```markdown
Check the latest version in the changelog...
```

## Use Consistent Terminology

Choose one term and stick with it:

- "API endpoint" (not mixing with "URL", "route", "path")
- "field" (not mixing with "box", "element", "control")
- "extract" (not mixing with "pull", "get", "retrieve")

## Use Forward Slashes in Paths

**Good:**

```
references/guide.md
scripts/helper.py
.claude/skills/creating-skills/SKILL.md
```

**Bad:**

```
reference\guide.md
scripts\helper.py
```

## What NOT to Include

Skills are for AI agents, not humans. Only include what's needed for Claude to do the job.

**Do NOT create these files:**

- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- CONTRIBUTING.md

**Do NOT include:**

- Setup and testing procedures
- User-facing documentation
- Development process notes
- Version history
- Installation instructions

**Why:** These files add clutter and confusion. The skill should contain only the information needed for an AI agent to execute the task effectively.
