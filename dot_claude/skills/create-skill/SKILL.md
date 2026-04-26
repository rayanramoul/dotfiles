---
name: create-skill
description: Create or update Claude Code skills following official best practices. Guides through naming conventions, structure requirements, progressive disclosure patterns, and quality standards. Automatically use when user requests to "create a skill", "update skill", "new skill for X", "improve skill", or mentions creating/modifying agent skills.
---

# Create Skill

Create or update Claude Code skills following official best practices.

## Core Principle: Context Efficiency

**The context window is a public good.** Skills share it with system prompts, conversation history, and user requests.

**Claude is already smart.** Only add what Claude doesn't know. Challenge each piece:
- "Does Claude really need this?"
- "Does this justify its token cost?"

**Extract aggressively.** SKILL.md should be a lean navigation map:

| Content Type | Where it goes | Why |
|--------------|---------------|-----|
| Detailed docs | `references/` | Only loaded when needed |
| Repeated code | `scripts/` | Executed, not read |
| Templates, images | `assets/` | Used in output, never loaded |

## How to Use This Skill

**Input:** Task description (create new skill or update existing)
**Output:** Complete skill following best practices

## Task Tracking (Required)

**You MUST use the task system to track progress through this skill.**

At the start:
1. Use `TaskCreate` to create tasks for each major step (e.g., "Understand task", "Choose name", "Create structure", "Write SKILL.md", "Validate")
2. Set `activeForm` for each task (e.g., "Understanding task requirements")

During execution:
1. Use `TaskUpdate` to mark the current task as `in_progress` before starting it
2. Use `TaskUpdate` to mark tasks as `completed` when done
3. Use `TaskList` to check overall progress

This provides visibility into skill execution and allows resumption if interrupted.

### Creating a New Skill

**Step 1: Understand the task**
- What problem does this skill solve?
- Does it need scripts, references, or assets?

**Step 2: Choose name (verb-noun format)**

Good: `plan-feature`, `validate-json`, `analyze-database`
Avoid: noun phrases, vague names, reserved words ("anthropic", "claude")

**Step 3: Write description**

```
[What it does]. [Key features]. Automatically use when user requests to "[trigger 1]", "[trigger 2]", "[trigger 3]".
```

**Step 4: Create structure**

```bash
mkdir -p .claude/skills/[skill-name]
mkdir -p .claude/skills/[skill-name]/references  # if needed
mkdir -p .claude/skills/[skill-name]/scripts     # if needed
mkdir -p .claude/skills/[skill-name]/assets      # if needed
```

**Step 5: Write SKILL.md**

Use template from [references/skill-template.md](references/skill-template.md).

Required sections:
- YAML frontmatter (name, description)
- H1 title
- "How to Use This Skill" with Input/Output

**Step 6: Extract to references**

Extract content >30 lines to `references/`. See [references/structure-reference.md](references/structure-reference.md) for patterns.

**Step 7: Validate**

Use [references/quality-checklist.md](references/quality-checklist.md).

Critical checks:
- ✅ Verb-noun naming
- ✅ Description has trigger phrases
- ✅ SKILL.md under 500 lines
- ✅ Content extracted to references

### Updating an Existing Skill

**Step 1: Read and assess**

```bash
wc -l .claude/skills/[skill-name]/SKILL.md
cat .claude/skills/[skill-name]/SKILL.md
```

**Step 2: Check against best practices**

- [ ] Name follows verb-noun convention?
- [ ] Description includes trigger phrases?
- [ ] Under 500 lines?
- [ ] Content extracted to references?

**Step 3: Apply fixes**

- **Naming issues** → Rename folder + update YAML + update paths
- **Size issues** → Extract to `references/`
- **Missing triggers** → Update description

**Step 4: Validate**

Run through [references/quality-checklist.md](references/quality-checklist.md).

## Reference Files

| File | Use when |
|------|----------|
| [skill-template.md](references/skill-template.md) | Creating new SKILL.md |
| [quality-checklist.md](references/quality-checklist.md) | Validating any skill |
| [structure-reference.md](references/structure-reference.md) | Understanding directories, progressive disclosure |
| [content-guidelines.md](references/content-guidelines.md) | Writing content, avoiding common mistakes |
| [workflow-patterns.md](references/workflow-patterns.md) | Choosing workflow structure |

## Examples

| Example | Shows |
|---------|-------|
| [example-simple.md](references/example-simple.md) | Instruction-only skill |
| [example-script-based.md](references/example-script-based.md) | Skill with Python scripts |
| [example-progressive.md](references/example-progressive.md) | Skill with extracted references |

## Important Guidelines

**DO:**
- ✅ Use verb-noun naming (e.g., `plan-feature`)
- ✅ Include trigger phrases in description
- ✅ Keep SKILL.md under 500 lines
- ✅ Extract detailed content to references
- ✅ Use forward slashes in paths

**DON'T:**
- ❌ Create README.md, CHANGELOG.md, etc.
- ❌ Include time-sensitive information
- ❌ Nest references (keep one level deep)
- ❌ Dump all content into SKILL.md
