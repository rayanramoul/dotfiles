# Workflow Patterns

## Table of Contents
- [Pattern 1: Workflow with Scripts](#pattern-1-workflow-with-scripts)
- [Pattern 2: Instruction-Only Workflow](#pattern-2-instruction-only-workflow)
- [Pattern 3: Feedback Loop](#pattern-3-feedback-loop)
- [Pattern 4: Conditional Workflow](#pattern-4-conditional-workflow)

## Pattern 1: Workflow with Scripts

For skills that execute Python/bash scripts:

````markdown
## How to Use This Skill

### Step 1: Prepare Input

[Instructions on what user needs ready]

### Step 2: Run Script

```bash
python3 .claude/skills/[skill-name]/scripts/script.py <input>
```
````

### Step 3: Review Output

[What to check, how to validate]

### Step 4: Handle Errors

[Common errors and solutions]

````

**Examples from existing skills:**
- `summarizing-stories` - Uses Python script to parse and generate
- `committing-stories` - Uses Python script to create commit messages

## Pattern 2: Instruction-Only Workflow

For skills without scripts (pure instructions):

```markdown
## How to Use This Skill

Follow this workflow:

1. **Analyze**: Understand the context
2. **Plan**: Create approach
3. **Execute**: Perform the task
4. **Validate**: Check results
5. **Iterate**: Refine if needed
````

**Example from existing skills:**
- `updating-epics` - Guided instructions for updating planning docs

## Pattern 3: Feedback Loop

For skills requiring iteration:

```markdown
## Workflow

1. Generate initial output
2. Validate against criteria
3. Identify issues
4. Fix issues
5. Validate again
6. If issues remain, return to step 4
7. Finalize output
```

## Pattern 4: Conditional Workflow

For skills with decision points:

```markdown
## Processing Workflow

1. Check input type
   - If PDF: Use pdf_extract.py
   - If Excel: Use excel_parser.py
   - If Word: Use docx_reader.py
2. Validate extracted data
3. If validation fails: Report errors and stop
4. If validation passes: Continue to processing
```
