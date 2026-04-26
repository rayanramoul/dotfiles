# Skill Structure Reference

## Table of Contents
- [YAML Frontmatter](#yaml-frontmatter)
- [Directory Types](#directory-types)
- [File Organization Examples](#file-organization-examples)
- [File Size Guidelines](#file-size-guidelines)
- [Progressive Disclosure Patterns](#progressive-disclosure-patterns)

## YAML Frontmatter

```yaml
---
name: verb-noun-format
description: One-line description (1024 chars max) with trigger phrases.
---
```

**Requirements:**

- `name`: 64 characters maximum, lowercase letters/numbers/hyphens only
- `name`: No XML tags, no reserved words ("anthropic", "claude")
- `description`: 1024 characters maximum, includes what/when/triggers

## Directory Types

| Directory | Purpose | Loaded into context? |
|-----------|---------|---------------------|
| `scripts/` | Executable code (Python/Bash) | No (only output) |
| `references/` | Documentation Claude reads as needed | Yes (when needed) |
| `assets/` | Templates, images, fonts for output | No (copied/used in output) |

**When to use each:**

- **scripts/**: Code that gets executed repeatedly or needs deterministic reliability
- **references/**: Documentation Claude should read while working (schemas, API docs, guides)
- **assets/**: Files used in output but not read into context (templates, images, boilerplate)

## File Organization Examples

**Minimal skill:**

```
skill-name/
└── SKILL.md
```

**Skill with scripts:**

```
skill-name/
├── SKILL.md
└── scripts/
    ├── script1.py
    └── script2.sh
```

**Skill with references:**

```
skill-name/
├── SKILL.md
└── references/
    ├── detailed-topic.md
    └── examples.md
```

**Skill with assets:**

```
skill-name/
├── SKILL.md
└── assets/
    ├── template.pptx
    ├── logo.png
    └── boilerplate/
        └── index.html
```

**Full skill structure:**

```
skill-name/
├── SKILL.md
├── scripts/          # Executable code
├── references/       # Documentation for Claude to read
└── assets/           # Files used in output (not read into context)
```

**Important:**

- Keep references one level deep (SKILL.md → references/file.md)
- Don't nest references (SKILL.md → ref1.md → ref2.md)
- Use descriptive file names (not doc1.md, doc2.md)
- Assets are copied/used, not read into context - keeps token usage efficient

## File Size Guidelines

**Target: Under 500 lines for SKILL.md**

If approaching 500 lines:

1. Extract detailed format specifications
2. Extract extensive examples
3. Extract troubleshooting details
4. Extract reference tables or lists
5. Keep workflow and key instructions in main file

## Progressive Disclosure Patterns

### Pattern: High-level guide with references

```markdown
## Section Overview

Brief description of what this section covers.

For detailed [topic], see [references/topic.md](references/topic.md).

**Quick summary:**

- Key point 1
- Key point 2
- Key point 3
```

### Pattern: Domain-specific organization

For skills with multiple domains, organize by domain so Claude only loads relevant context:

```
data-query/
├── SKILL.md (overview and navigation)
└── references/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage, features)
    └── marketing.md (campaigns, attribution)
```

When user asks about sales metrics, Claude only reads `sales.md`.

### Pattern: Variant/framework organization

For skills supporting multiple frameworks or variants:

```
cloud-deploy/
├── SKILL.md (workflow + provider selection)
└── references/
    ├── aws.md (AWS deployment patterns)
    ├── gcp.md (GCP deployment patterns)
    └── azure.md (Azure deployment patterns)
```

When user chooses AWS, Claude only reads `aws.md`.

### Structuring longer reference files

For reference files longer than 100 lines, include a table of contents at the top:

```markdown
# API Reference

## Table of Contents
- [Authentication](#authentication)
- [Endpoints](#endpoints)
- [Error Handling](#error-handling)
- [Examples](#examples)

## Authentication
...
```
