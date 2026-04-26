---
description: Create or update a reusable skill / command file following progressive-disclosure best practices. Use when the user asks to "create a skill", "new command for X", "improve skill", or wants to package a multi-step workflow.
---

# Create Skill / Command

Create a reusable skill (Claude Code) or slash command (opencode) following the same progressive-disclosure principles. Both target the same problem: package a multi-step workflow so it can be invoked later by name.

## Core principle: context efficiency

The context window is a public good. The skill / command file shares it with system prompts, conversation history, and the user request.

The model is already capable. Only add what it doesn't know. Challenge each line:
- "Does the model really need this here?"
- "Does this justify its token cost?"

Extract aggressively:

| Content type | Where it goes | Why |
|--------------|---------------|-----|
| Detailed docs | `references/` (Claude Code skills) | Loaded only when needed |
| Repeated code | `scripts/` | Executed, not read |
| Templates, images | `assets/` | Used in output, never loaded |

opencode commands are single files — for an opencode-only workflow, keep the file under ~150 lines and link out to other docs in the repo if you need more.

## Steps

**1. Understand the task** — what problem does this skill solve? Does it need scripts, references, or assets?

**2. Choose a name (verb-noun)**
- Good: `plan-feature`, `validate-json`, `analyze-database`
- Avoid: noun phrases, vague names, reserved words ("anthropic", "claude")

**3. Write a description**

```
[What it does]. [Key features]. Use when the user asks to "[trigger 1]", "[trigger 2]", "[trigger 3]".
```

**4. Pick the surface**
- **Claude Code skill** → `~/.claude/skills/<name>/SKILL.md` (+ optional `references/`, `scripts/`, `assets/`).
- **opencode command** → `~/.config/opencode/command/<name>.md` (single file).
- **Project-scoped** → `.claude/skills/<name>/SKILL.md` or `.opencode/command/<name>.md` instead of the home directory.

**5. Write the file**

YAML frontmatter is required for both:

```yaml
---
name: verb-noun        # Claude Code skills only
description: One sentence with trigger phrases. Max 1024 chars.
---
```

opencode commands take only `description` (and optionally `agent`).

Sections to include (in order):
- H1 title
- A short "How to use" / "Inputs / Outputs" block
- The actual workflow steps
- Links to references for anything detailed

**6. Extract content over ~30 lines** to references (Claude Code) or to a docs file in the repo (opencode).

**7. Validate** — run through this checklist before saving:
- [ ] Verb-noun naming
- [ ] Description includes trigger phrases
- [ ] SKILL.md / command file under 500 lines (skills) / 150 lines (opencode commands)
- [ ] Detailed content extracted, not inlined
- [ ] No README.md, CHANGELOG.md, or time-sensitive notes inside the skill

## Important

**DO**
- Use forward slashes in paths.
- Include trigger phrases the user actually says.
- Keep references one level deep.

**DON'T**
- Create README.md, CHANGELOG.md inside the skill folder.
- Nest references (SKILL.md → ref1.md → ref2.md).
- Dump everything into the main file.
- Ask the user to confirm boilerplate decisions — pick sensible defaults and surface only the meaningful choices.

## When the surface should be both

If the workflow should be available in both Claude Code *and* opencode:
1. Author the Claude Code skill first (richer structure).
2. Drop a thin opencode wrapper at `~/.config/opencode/command/<name>.md` whose body summarises the same steps and links to the canonical SKILL.md (or its references) for depth.

Don't try to share the file across tools — formats and tool-call vocabularies differ. Sharing the *content* via a chezmoi template (`.chezmoitemplates/`) is fine and cheap when the body is identical.
