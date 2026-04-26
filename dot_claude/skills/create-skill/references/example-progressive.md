# Example: Skill with Progressive Disclosure

This example shows how to use progressive disclosure to keep SKILL.md under 500 lines while providing detailed documentation in reference files.

## Structure

```
analyze-database/
├── SKILL.md                    (380 lines)
├── references/
│   ├── query-patterns.md      (Detailed SQL patterns)
│   ├── optimization-guide.md  (Performance tuning)
│   └── examples.md            (Extended examples)
└── scripts/
    ├── analyze_schema.py
    └── generate_report.py
```

## Main SKILL.md (Condensed)

````markdown
---
name: analyze-database
description: Analyze database schemas, performance, and data quality issues. Uses Python scripts to generate reports on indexes, queries, and optimization opportunities. Automatically use when user requests to "analyze database", "check database performance", "review schema", or needs database optimization insights.
---

# Analyze Database

Analyze database schemas, performance, and data quality. This skill generates comprehensive reports on database health, optimization opportunities, and best practice violations.

## How to Use This Skill

**Input:** Database connection string
**Output:** Analysis report with recommendations

### Step 1: Connect to Database

```bash
python3 .claude/skills/analyze-database/scripts/analyze_schema.py \\
  --host localhost \\
  --database mydb \\
  --user readonly \\
  --password [password]
```
````

### Step 2: Review Schema Report

The script outputs a report with:

- Table structure analysis
- Index coverage
- Constraint violations
- Suggested improvements

### Step 3: Analyze Performance

For detailed query optimization patterns, see [references/query-patterns.md](references/query-patterns.md).

**Key patterns:**

- Use indexes for WHERE clauses
- Avoid SELECT \* in production
- Use EXPLAIN to understand query plans
- Consider partitioning for large tables

### Step 4: Implement Improvements

For detailed optimization guide, see [references/optimization-guide.md](references/optimization-guide.md).

**Quick wins:**

- Add missing indexes (highest impact)
- Update statistics
- Fix N+1 query problems
- Implement query caching

### Step 5: Validate Changes

```bash
# Rerun analysis after changes
python3 .claude/skills/analyze-database/scripts/analyze_schema.py [options]

# Compare before/after reports
```

## Analysis Categories

### 1. Schema Health

- Missing indexes
- Redundant indexes
- Constraint violations
- Data type issues

### 2. Performance

- Slow queries
- Missing statistics
- Inefficient joins
- Full table scans

### 3. Data Quality

- Null constraints
- Foreign key integrity
- Duplicate data
- Orphaned records

## Common Issues

### Missing Index

**Detection:** Full table scan in EXPLAIN
**Impact:** Slow queries as data grows
**Fix:** Add index on frequently queried columns

See [references/optimization-guide.md](references/optimization-guide.md#adding-indexes) for detailed indexing strategies.

### N+1 Queries

**Detection:** Multiple sequential queries in loop
**Impact:** High latency, database load
**Fix:** Use JOIN or eager loading

See [references/query-patterns.md](references/query-patterns.md#avoiding-n-plus-1) for examples and patterns.

## Script Details

### analyze_schema.py

- Connects to database (read-only)
- Generates schema analysis
- No data modifications
- Outputs JSON report

**Dependencies:**

- Python 3.8+
- `psycopg2` (PostgreSQL)
- `sqlalchemy` (multi-database support)

## Examples

For complete examples with real schemas and optimizations, see [references/examples.md](references/examples.md).

**Quick example:**

```bash
# Analyze local PostgreSQL database
python3 .claude/skills/analyze-database/scripts/analyze_schema.py \\
  --host localhost \\
  --database production \\
  --user analyst

# Output: Report saved to analysis_report_YYYYMMDD_HHMMSS.json
```

## Important Guidelines

**DO:**

- ✅ Use read-only database user
- ✅ Analyze during low-traffic periods
- ✅ Review recommendations before implementing
- ✅ Test index changes in staging first
- ✅ Monitor impact after changes

**DON'T:**

- ❌ Run analysis on production without review
- ❌ Add indexes without testing
- ❌ Make schema changes without backups
- ❌ Ignore data distribution statistics
- ❌ Optimize prematurely without profiling

## Notes

- Always use read-only credentials
- Test recommendations in non-production first
- Monitor query performance after changes
- Schedule regular analysis

````

## Reference File: query-patterns.md (Detailed Content)

```markdown
# Query Optimization Patterns

Detailed patterns and examples for optimizing database queries.

## Table of Contents
- [Index Usage Patterns](#index-usage-patterns)
- [Join Optimization](#join-optimization)
- [Avoiding N+1 Queries](#avoiding-n-plus-1)
- [Subquery vs. Join](#subquery-vs-join)
- [Pagination Patterns](#pagination-patterns)

## Index Usage Patterns

### Pattern 1: Single Column Index

**When to use:**
- Column frequently in WHERE clause
- Column used in ORDER BY
- High cardinality (many unique values)

**Example:**
```sql
-- Without index: Full table scan
SELECT * FROM users WHERE email = 'user@example.com';
-- Execution time: 2500ms

-- Add index
CREATE INDEX idx_users_email ON users(email);

-- With index: Index seek
SELECT * FROM users WHERE email = 'user@example.com';
-- Execution time: 5ms
````

### Pattern 2: Composite Index

[... extensive examples continue ...]

## Avoiding N+1 Queries {#avoiding-n-plus-1}

### The Problem

**Bad: N+1 Query Pattern**

```python
# Fetches 1 query for posts, then N queries for authors
posts = Post.query.all()  # 1 query
for post in posts:
    author = post.author.name  # N queries!
```

[... detailed examples and solutions continue for 200+ lines ...]

````

## Reference File: optimization-guide.md (Detailed Content)

```markdown
# Database Optimization Guide

Comprehensive guide to database performance tuning.

## Table of Contents
- [Adding Indexes](#adding-indexes)
- [Query Rewriting](#query-rewriting)
- [Partitioning Strategies](#partitioning-strategies)
- [Caching Approaches](#caching-approaches)

## Adding Indexes {#adding-indexes}

### When to Add an Index

Decision flowchart:
1. Is column in WHERE, JOIN, or ORDER BY?
2. Does query scan many rows?
3. Is column high cardinality?
4. Is read performance critical?

If yes to all → Add index

### Index Types

**B-Tree Index (Default)**
- Best for: Exact matches, range queries
- Example: `CREATE INDEX idx_name ON table(column);`

[... extensive optimization guide continues ...]
````

## Key Characteristics of Progressive Disclosure

1. **Main file stays under 500 lines**
   - High-level overview
   - Essential workflows
   - Quick reference

2. **Reference files contain details**
   - Extensive examples
   - Deep technical content
   - Comprehensive guides

3. **Clear links between files**
   - "See [references/file.md](references/file.md) for details"
   - Brief summary before link
   - Specific anchor links (#section-name)

4. **One level deep**
   - SKILL.md → references/file.md (✅)
   - Not: SKILL.md → ref1.md → ref2.md (❌)

5. **Descriptive file names**
   - `query-patterns.md` not `doc1.md`
   - `optimization-guide.md` not `guide.md`
   - `examples.md` not `ex.md`

## When to Use Progressive Disclosure

**Use when:**

- SKILL.md exceeds 400 lines
- Skill has extensive examples
- Detailed format specifications needed
- Multiple complex topics covered
- Reference tables or lists are long

**Don't use when:**

- Skill is simple and under 300 lines
- Content is already concise
- Splitting would make workflow unclear
- References would be tiny files

## Benefits

1. **Better performance**: Claude loads only what's needed
2. **Clearer structure**: Main file is navigable
3. **Easier maintenance**: Update specific files
4. **Focused context**: Details don't clutter main workflow

## Pattern from Existing Skills

**summarizing-stories** (423 lines after splitting):

- Main file: Workflow and overview
- `references/output-format.md`: Detailed format spec (250+ lines)

**summarizing-epics** (330 lines after splitting):

- Main file: Workflow and key sections
- `references/output-format.md`: Complete format documentation

Both follow this pattern:

1. Keep workflow in main file
2. Extract format specifications
3. Link with brief summary
4. One level of references
