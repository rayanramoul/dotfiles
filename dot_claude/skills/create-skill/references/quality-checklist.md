# Quality Checklist for Skills

Use this checklist to validate skills before finalizing.

## Core Quality

### Naming

- [ ] Name follows verb-noun format (e.g., plan-feature)
- [ ] Name is lowercase with hyphens (letters, numbers, hyphens only)
- [ ] Name is descriptive and specific (not vague like "helper" or "utils")
- [ ] Name is 64 characters or less
- [ ] Name contains no XML tags
- [ ] Name contains no reserved words ("anthropic", "claude")
- [ ] Folder name matches YAML `name` field
- [ ] H1 title uses title case (e.g., "Summarizing Stories")

### Description

- [ ] Description is specific and includes key terms
- [ ] Description includes both what the skill does and when to use it
- [ ] Description uses "Automatically use when user requests to..."
- [ ] Description includes 3-5 trigger phrases in quotes
- [ ] Description includes variations of trigger phrases
- [ ] Description is 1024 characters or less
- [ ] No first-person language ("I can help" or "You can use")

### File Size

- [ ] SKILL.md body is under 500 lines
- [ ] If over 500 lines, content is split into reference files
- [ ] Progressive disclosure pattern used appropriately
- [ ] Reference files are one level deep (not nested)

### Template Handling

- [ ] Templates >30 lines extracted to reference files
- [ ] Template files named descriptively (e.g., `epic-template.md`, `output-format.md`)
- [ ] SKILL.md has brief overview and link to template
- [ ] Template files include complete structure with examples

### Content Quality

- [ ] No time-sensitive information (no "As of 2024")
- [ ] Consistent terminology throughout
- [ ] Examples are concrete, not abstract
- [ ] Workflows have clear steps
- [ ] Decision points are explicit

### Paths and References

- [ ] No Windows-style paths (all forward slashes)
- [ ] All script paths are correct
- [ ] Reference file links work
- [ ] Internal references updated if skill was renamed

## Structure

### YAML Frontmatter

- [ ] Has `name` field
- [ ] Has `description` field
- [ ] All fields properly formatted
- [ ] No extra or missing fields

### Required Sections

- [ ] H1 title (matches skill purpose)
- [ ] "How to Use This Skill" section (step-by-step instructions with output specification)

### Recommended Sections (if applicable)

- [ ] Input/Output specification
- [ ] Expected format (if skill has format requirements)
- [ ] Error handling
- [ ] Important guidelines
- [ ] Examples
- [ ] Script details (if using scripts)

## Code and Scripts (if applicable)

### Scripts

- [ ] Scripts solve problems rather than punt to Claude
- [ ] Error handling is explicit and helpful
- [ ] Required packages listed in instructions
- [ ] Scripts have clear documentation
- [ ] Script paths referenced correctly in SKILL.md

### Instructions

- [ ] Clear execution instructions
- [ ] Input/output examples provided
- [ ] Error scenarios documented
- [ ] Dependencies listed

## Progressive Disclosure (if used)

### Reference Files

- [ ] Reference files are one level deep from SKILL.md
- [ ] File names are descriptive
- [ ] Links from SKILL.md to reference files work
- [ ] Brief summary provided in SKILL.md before linking
- [ ] Reference files have clear structure
- [ ] Reference files >100 lines have table of contents at top

### Organization

- [ ] Main SKILL.md has high-level overview
- [ ] Detailed content in reference files
- [ ] Clear when to read reference files
- [ ] No deeply nested references

## Testing

### Functional Testing

- [ ] Tested trigger phrases work
- [ ] Workflows can be followed
- [ ] Examples are correct and working
- [ ] Scripts execute successfully (if applicable)
- [ ] Error handling works

### Documentation Testing

- [ ] Instructions are clear and unambiguous
- [ ] Examples match actual behavior
- [ ] Links to reference files work
- [ ] No broken internal references

## Final Checks

- [ ] Skill name is unique (doesn't conflict with existing skills)
- [ ] All internal paths updated if skill was renamed
- [ ] No leftover references to old names
- [ ] Consistent with patterns from existing skills
- [ ] Ready for real usage scenarios

## Quick Validation Commands

```bash
# Check line count
wc -l .claude/skills/[skill-name]/SKILL.md

# Should be under 500

# Check for time-sensitive info
grep -i "as of\|202[0-9]\|current version" .claude/skills/[skill-name]/SKILL.md

# Should return nothing

# Check for Windows paths
grep '\\' .claude/skills/[skill-name]/SKILL.md | grep -v "newline"

# Should return nothing or only bash line continuations

# List skill names to verify verb-noun format
ls .claude/skills/

# Names should follow verb-noun pattern (e.g., plan-feature, define-feature)

# Verify description length
head -10 .claude/skills/[skill-name]/SKILL.md | grep "description:"

# Should be under 1024 characters
```

## Common Issues to Fix

### Issue: Name not in verb-noun format

**Fix**: Rename folder and update YAML `name` field, H1 title, and all references. Use format like `plan-feature`, `define-feature`.

### Issue: File over 500 lines

**Fix**: Extract sections to `references/` files, keep overview in main file

### Issue: No trigger phrases in description

**Fix**: Add "Automatically use when user requests to..." with quoted phrases

### Issue: Time-sensitive information

**Fix**: Remove "As of [year]" statements, use "Check latest..." instead

### Issue: Windows paths (backslashes)

**Fix**: Change all `\` to `/` in paths (except bash line continuations)

### Issue: Vague or generic name

**Fix**: Be more specific about what the skill does (avoid "helper", "manager", "processor" without context)

### Issue: Inconsistent terminology

**Fix**: Choose one term and use it throughout (e.g., always "API endpoint", not mixing with "URL" or "route")

### Issue: No examples

**Fix**: Add at least one concrete example of skill usage

### Issue: Nested references

**Fix**: Flatten structure so all references are directly from SKILL.md

### Issue: Description too long

**Fix**: Reduce to essential information, move details to SKILL.md body
