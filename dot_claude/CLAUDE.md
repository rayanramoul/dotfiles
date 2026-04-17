# User-level preferences

These apply across all projects. When a project has its own `CLAUDE.md`, `AGENTS.md`, or `.cursor/rules/*`, defer to the project's instructions where they conflict.

## Code quality rules (universal)
- **DRY where it reduces complexity** — three similar lines are fine; the same block repeated across modules is not.
- **No dead code** — grep before deleting to confirm no callers (include configs, scripts, entry points, tests).
- **No circular imports** — extract the shared piece into a lower-level module rather than patching with local imports or conditional-import workarounds.
- **No weak types** — `Any`, untyped `dict` / `list`, bare `object`, or blanket type-suppressions need a written one-line justification.
- **No defensive try/except** — only catch at real boundaries (user input, external APIs, filesystem, network, subprocess) with a concrete handling strategy. Never swallow exceptions. Never silent fallback.
- **One code path** — remove deprecated / legacy / "just in case" branches; don't keep both.
- **No AI slop comments** — no narrating in-motion work, no "was X, now Y", no restating what the code already says. Comments only for non-obvious *why* (constraints, invariants, workarounds).

## Ask before
- Modifying dependency versions in any manifest or lockfile (`pyproject.toml` / `package.json` / `Cargo.toml` / `go.mod` / `uv.lock` / `package-lock.json` / …).
- Adding a new dependency.
- Deleting files (source, config, docs, data).
- Deleting or modifying any pre-existing unit test (adding new tests is fine).
- Pushing, force-pushing, or editing CI workflow files.

A one-off "ok" is scoped to the same session and operation; it doesn't authorise unrelated changes.

## Large changes — interview first, then spec, then fresh session
If the request looks sizeable (new module / package, cross-cutting refactor, new pipeline, migration, anything that would span many files and hours), pause before coding and offer to interview me using the `AskUserQuestion` tool. Dig into technical trade-offs, API / CLI / config shape, edge cases, and concerns I might not have considered. Skip obvious questions — focus on the hard parts. When the interview converges, write the agreed design to `SPEC.md` and suggest continuing in a **fresh session** with clean context.

Small fixes and well-specified changes should proceed directly.

## Feedback loop — propose persisting rules or skills
If I correct or guide you on the same thing **more than once in a session**, offer to make it stick across sessions — and pick the right surface:
- **Short project-wide rule** → add it to the project's `CLAUDE.md` / `AGENTS.md` / `.cursor/rules/…`, whichever the project uses.
- **Short global rule** (tool or style preference that applies everywhere) → add it to `~/.claude/CLAUDE.md`.
- **Multi-step or task-specific workflow with steps / arguments / side effects** → create a skill at `.claude/skills/<name>/SKILL.md` (project-level) or `~/.claude/skills/<name>/SKILL.md` (global) with `name` and `description` frontmatter. Add `disable-model-invocation: true` when the flow should only run on an explicit `/<name>` invocation, not auto-applied.

Do not edit any rule file or create skills without explicit confirmation.

## Default tool preferences
- Use the project's existing task runner (`just`, `make`, `npm run …`, `bun run …`, `cargo`, `go`) over ad-hoc shell invocations.
- Use the project's existing package / dependency manager. Never introduce a new one without asking.
- Use the project's existing linter / formatter / type-checker — don't re-do their job manually. If one is configured but not running, ask before changing its config.
- Prefer built-in tools (`Read` / `Edit` / `Grep` / `Glob`) over shelling out to `cat` / `sed` / `awk` / `find` / `grep`.
- Prefer editing existing files over creating new ones. Don't create documentation files (`*.md`, `README*`) unless explicitly asked.
