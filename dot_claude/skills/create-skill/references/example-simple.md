# Example: Simple Instruction-Only Skill

This example shows a skill that uses only markdown instructions without any scripts.

````markdown
---
name: review-code
description: Review code for best practices, potential bugs, and improvements. Analyzes code structure, style, security, and performance. Automatically use when user requests to "review code", "check this code", "code review", or provides code asking for feedback.
---

# Review Code

Review code for best practices, potential bugs, and improvements. This skill provides structured code review following industry standards and project conventions.

## How to Use This Skill

**Input:** Code snippet or file path
**Output:** Structured review with recommendations

### Step 1: Understand Context

Ask clarifying questions if needed:

- What is the code's purpose?
- Are there specific concerns or areas to focus on?
- What is the experience level of the author?
- Are there project-specific conventions to follow?

### Step 2: Analyze Code Structure

Review the code systematically:

1. **Architecture**: Is the overall structure appropriate?
2. **Naming**: Are variables, functions, classes well-named?
3. **Logic**: Is the flow clear and correct?
4. **Error Handling**: Are errors handled appropriately?

### Step 3: Check Best Practices

Verify adherence to best practices:

- **DRY Principle**: Is code unnecessarily repeated?
- **SOLID Principles**: For object-oriented code
- **Separation of Concerns**: Is logic appropriately separated?
- **Readability**: Is code easy to understand?

### Step 4: Identify Issues

Look for common problems:

- **Bugs**: Logic errors, edge cases not handled
- **Security**: SQL injection, XSS, insecure patterns
- **Performance**: Inefficient algorithms, unnecessary operations
- **Maintainability**: Complex logic, unclear intent

### Step 5: Provide Feedback

Structure your review:

```markdown
## Code Review: [File/Function Name]

### ✅ Strengths

- [What is done well]
- [Good patterns used]

### ⚠️ Issues Found

#### High Priority

- **Issue**: [Description]
  **Location**: Line X
  **Impact**: [Why this matters]
  **Fix**: [How to fix it]

#### Medium Priority

[Continue with medium priority issues]

#### Low Priority

[Continue with low priority issues]

### 💡 Suggestions

- [Improvement 1 with code example]
- [Improvement 2 with code example]

### 📚 Resources

- [Relevant documentation or articles]
```
````

## Review Categories

### 1. Correctness

- Does the code do what it's supposed to do?
- Are edge cases handled?
- Are there logical errors?

### 2. Security

- Are inputs validated?
- Is sensitive data protected?
- Are there injection vulnerabilities?

### 3. Performance

- Are algorithms efficient?
- Are resources used appropriately?
- Could performance be improved without sacrificing readability?

### 4. Maintainability

- Is code readable and understandable?
- Is it easy to modify or extend?
- Are there comments where needed?

### 5. Style

- Does it follow project conventions?
- Is formatting consistent?
- Are naming conventions followed?

## Important Guidelines

**DO:**

- ✅ Be specific with examples
- ✅ Explain the "why" behind recommendations
- ✅ Provide code examples for suggested changes
- ✅ Prioritize issues by severity
- ✅ Acknowledge what is done well
- ✅ Consider the context and constraints

**DON'T:**

- ❌ Be vague ("this could be better")
- ❌ Focus only on style over substance
- ❌ Suggest changes without explanation
- ❌ Ignore positive aspects
- ❌ Overwhelm with minor nitpicks
- ❌ Assume one "right" way without context

## Example Usage

**User provides code:**

```python
def get_user(id):
    user = db.query("SELECT * FROM users WHERE id = " + id)
    return user
```

**Review:**

````markdown
## Code Review: get_user function

### ⚠️ Critical Issue

**Issue**: SQL Injection Vulnerability
**Location**: Line 2
**Impact**: Attackers can execute arbitrary SQL by manipulating the id parameter
**Fix**: Use parameterized queries

**Recommended:**

```python
def get_user(id):
    user = db.query("SELECT * FROM users WHERE id = %s", (id,))
    return user
```
````

### 💡 Additional Suggestions

1. **Add type hints for clarity:**

```python
def get_user(id: int) -> Optional[User]:
    user = db.query("SELECT * FROM users WHERE id = %s", (id,))
    return user
```

2. **Add error handling:**

```python
def get_user(id: int) -> Optional[User]:
    try:
        user = db.query("SELECT * FROM users WHERE id = %s", (id,))
        return user
    except DatabaseError as e:
        logger.error(f"Failed to fetch user {id}: {e}")
        return None
```

3. **Consider using ORM for type safety:**

```python
def get_user(id: int) -> Optional[User]:
    return User.query.filter_by(id=id).first()
```

```

## Notes

- Tailor review depth to user's experience level
- Focus on teaching, not just pointing out errors
- Provide resources for learning more
- Balance thoroughness with practicality
```

## Key Characteristics of This Example

1. **No scripts** - Pure instruction-based workflow
2. **Clear phases** - Analysis → Review → Recommendations
3. **Structured output** - Template for consistent reviews
4. **Decision points** - Categories to check, priorities to assign
5. **Examples** - Shows both bad and good code
6. **Guidelines** - Clear DO/DON'T lists
