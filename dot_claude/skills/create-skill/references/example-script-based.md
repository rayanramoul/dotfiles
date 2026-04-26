# Example: Script-Based Skill

This example shows a skill that uses Python scripts for reliable execution.

````markdown
---
name: validate-json
description: Validate JSON files against schemas and check for common issues. Uses Python script with jsonschema library for strict validation. Automatically use when user requests to "validate json", "check json file", "verify json schema", or needs to ensure JSON correctness.
---

# Validate JSON

Validate JSON files against schemas and check for common issues. This skill uses a Python script to provide reliable, consistent validation with detailed error reporting.

## How to Use This Skill

**Input:** JSON file path, optional schema file path
**Output:** Validation report with errors or success confirmation

### Step 1: Verify Files Exist

```bash
# Check JSON file exists
ls path/to/file.json

# Check schema file exists (if validating against schema)
ls path/to/schema.json
```
````

### Step 2: Run Validation Script

**Basic validation (syntax only):**

```bash
python3 .claude/skills/validating-json/scripts/validate.py path/to/file.json
```

**Validation with schema:**

```bash
python3 .claude/skills/validating-json/scripts/validate.py \\
  path/to/file.json \\
  --schema path/to/schema.json
```

**Validation with custom rules:**

```bash
python3 .claude/skills/validating-json/scripts/validate.py \\
  path/to/file.json \\
  --schema path/to/schema.json \\
  --strict  # Enable additional checks
```

### Step 3: Interpret Results

**Success output:**

```
✅ JSON validation successful
File: path/to/file.json
Valid: Yes
Schema: path/to/schema.json (if provided)
No errors found
```

**Error output:**

```
❌ JSON validation failed
File: path/to/file.json

Errors:
1. Syntax Error at line 15, column 23
   - Missing comma after object property
   - Found: "property" "value"
   - Expected: "property": "value",

2. Schema Violation at $.user.email
   - Value "invalid-email" does not match format "email"
   - Required format: user@domain.com

Total errors: 2
```

### Step 4: Fix Issues

Address errors based on type:

**Syntax errors:**

- Check line/column indicated
- Verify commas, brackets, quotes
- Use a JSON formatter to identify issues

**Schema violations:**

- Check the data type matches schema
- Verify required fields are present
- Ensure value formats are correct

**After fixing, rerun validation to confirm**

## Script Details

### validate.py

**Purpose**: Validate JSON files with detailed error reporting

**Input:**

- JSON file path (required)
- Schema file path (optional, via --schema)
- Strict mode flag (optional, via --strict)

**Output:**

- Exit code 0: Validation successful
- Exit code 1: Validation failed
- JSON-formatted error report to stdout

**Dependencies:**

- Python 3.7+
- `jsonschema` package (install: `pip install jsonschema`)

**Error Handling:**

- File not found → Clear error message with path
- Invalid JSON syntax → Line/column information
- Schema validation errors → Path to violating element
- Schema file errors → Clear indication of schema issues

## Validation Levels

### Level 1: Syntax Validation (Default)

- Checks if JSON is parseable
- Reports syntax errors with line numbers
- No schema required

### Level 2: Schema Validation

- Validates structure against JSON Schema
- Checks data types, required fields
- Verifies format constraints (email, URL, etc.)

### Level 3: Strict Validation (--strict flag)

- All Level 2 checks
- Warns about additional properties not in schema
- Checks for common anti-patterns
- Validates consistent formatting

## Error Handling

### Error: File Not Found

**Symptom:**

```
Error: JSON file not found: path/to/file.json
```

**Solution:**

- Verify the file path is correct
- Check current working directory
- Use absolute paths if relative paths fail

### Error: Invalid JSON Syntax

**Symptom:**

```
Syntax Error at line 10, column 5
```

**Solution:**

- Check indicated line for missing commas, brackets, or quotes
- Use online JSON validator to identify issues
- Validate closing brackets match opening brackets

### Error: Schema Validation Failed

**Symptom:**

```
Schema Violation at $.user.age
Value "twenty" does not match type "integer"
```

**Solution:**

- Check the data type at the indicated path
- Refer to schema for expected type
- Convert value to correct type

### Error: Schema File Invalid

**Symptom:**

```
Error: Schema file is not valid JSON Schema
```

**Solution:**

- Validate the schema file itself
- Check schema follows JSON Schema specification
- Verify schema version compatibility

## Important Guidelines

**DO:**

- ✅ Always validate JSON before processing
- ✅ Use schemas for consistent data structure
- ✅ Fix errors one at a time, starting from first
- ✅ Revalidate after each fix
- ✅ Keep schemas version-controlled

**DON'T:**

- ❌ Skip validation for "trusted" data
- ❌ Ignore warnings in strict mode
- ❌ Hand-edit complex JSON without validation
- ❌ Use loose validation in production
- ❌ Assume JSON is valid if it "looks right"

## Example Usage

### Example 1: Basic Validation

**File: config.json**

```json
{
  "server": {
    "host": "localhost"
    "port": 8080
  }
}
```

**Command:**

```bash
python3 .claude/skills/validating-json/scripts/validate.py config.json
```

**Output:**

```
❌ JSON validation failed
File: config.json

Errors:
1. Syntax Error at line 4, column 5
   - Missing comma after "localhost"
   - Expected: "localhost",
```

**Fix:**

```json
{
  "server": {
    "host": "localhost",
    "port": 8080
  }
}
```

**Revalidate:**

```bash
python3 .claude/skills/validating-json/scripts/validate.py config.json
```

**Output:**

```
✅ JSON validation successful
File: config.json
Valid: Yes
No errors found
```

### Example 2: Schema Validation

**File: user.json**

```json
{
  "username": "john_doe",
  "email": "invalid-email",
  "age": "25"
}
```

**Schema: user-schema.json**

```json
{
  "type": "object",
  "required": ["username", "email", "age"],
  "properties": {
    "username": { "type": "string" },
    "email": { "type": "string", "format": "email" },
    "age": { "type": "integer", "minimum": 0 }
  }
}
```

**Command:**

```bash
python3 .claude/skills/validating-json/scripts/validate.py \\
  user.json \\
  --schema user-schema.json
```

**Output:**

```
❌ JSON validation failed
File: user.json
Schema: user-schema.json

Errors:
1. Schema Violation at $.email
   - Value "invalid-email" does not match format "email"
   - Required format: name@domain.com

2. Schema Violation at $.age
   - Value "25" has incorrect type
   - Expected: integer, Found: string

Total errors: 2
```

## Notes

**Why Use Scripts for Validation:**

- Consistent behavior across runs
- Detailed error reporting
- Handles edge cases reliably
- No risk of Claude misunderstanding JSON rules
- Can be integrated into CI/CD pipelines

**Script vs. Instructions:**

- Use scripts when precision matters
- Use instructions when context/judgment needed
- Scripts are better for validation, parsing, data processing
- Instructions are better for analysis, review, creative tasks

```

## Key Characteristics of This Example

1. **Python script** - Reliable execution for validation
2. **Clear invocation** - Bash commands with options
3. **Error handling** - Specific error scenarios documented
4. **Examples** - Real JSON with errors and fixes
5. **Script details** - Purpose, dependencies, error handling
6. **Workflow** - Run → Interpret → Fix → Rerun pattern
```
