# Skill Template

Use this template when creating a new skill.

````markdown
---
name: [verb-noun]
description: [What it does]. [Key features]. Automatically use when user requests to "[trigger 1]", "[trigger 2]", "[trigger 3]", or [contextual trigger].
---

# [Skill Title] (Title Case)

[One paragraph overview of what this skill does and why it exists]

## How to Use This Skill

**Input:** [What input is needed]
**Output:** [What output is produced]

### Step 1: [Step Name]

[Detailed instructions for this step]

**If using scripts:**

```bash
python3 .claude/skills/[skill-name]/scripts/[script.py] <input>
```
````

**If instruction-only:**
[Clear step-by-step instructions]

### Step 2: [Step Name]

[Continue with workflow steps]

### Step 3: [Step Name]

[Include decision points if needed]

- If X: Do Y
- If Z: Do W

## [Optional: Input Format / Expected Format]

[If skill expects specific input format, document it here]

## [Optional: Output Format]

[If skill produces specific output format, document it here]

For detailed format specification, see [references/output-format.md](references/output-format.md).

## Error Handling

### [Error Type 1]

**Symptom**: [How to recognize this error]
**Cause**: [Why it happens]
**Solution**: [How to fix it]

### [Error Type 2]

[Continue with common errors]

## Important Guidelines

**DO:**

- ✅ [Key guideline 1]
- ✅ [Key guideline 2]
- ✅ [Key guideline 3]

**DON'T:**

- ❌ [Anti-pattern 1]
- ❌ [Anti-pattern 2]
- ❌ [Anti-pattern 3]

## [Optional: Script Details]

[If skill uses scripts, document them]

**Script name**: `scripts/[script.py]`

- **Purpose**: [What it does]
- **Input**: [What it accepts]
- **Output**: [What it produces]
- **Dependencies**: [Required packages]

## [Optional: Assets]

[If skill uses assets (templates, images, boilerplate), list them]

**Assets included:**

- `assets/template.pptx` - PowerPoint template for output
- `assets/logo.png` - Brand logo for documents
- `assets/boilerplate/` - Starter project files

## Example Usage

[Provide concrete example of using the skill]

```bash
# Step 1: [Description]
[command or action]

# Step 2: [Description]
[command or action]

# Result: [What you get]
```

## Notes

[Any additional important information]

```

```
