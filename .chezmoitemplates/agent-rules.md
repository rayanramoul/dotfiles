# Agent Rules

These apply across projects unless a repository-specific `CLAUDE.md`, `AGENTS.md`, or `.cursor/rules/*` says otherwise.

## Code quality
- Keep changes minimal and remove duplication only when it actually reduces complexity.
- Consolidate shared shapes and types instead of redefining them in multiple places.
- Check for callers before deleting code, configs, scripts, or tests.
- Avoid circular imports; move shared logic to a lower-level module.
- Avoid weak typing unless you can justify it in one line.
- Do not add broad `try/except` blocks or silent fallbacks.
- Prefer one clear code path over legacy branches and `just in case` logic.
- Write comments for non-obvious intent, constraints, or invariants only.

## Typed code
- Type every function.
- Use modern syntax for the language in use.
- Keep docstrings and JSDoc short and only when they add real value.
- Follow the formatter and line-length rules already used by the project.
- Treat caching and memoization as opt-in, not a default.

## Testing
- Mirror the source layout under `tests/` or the project's existing test structure.
- Prefer parametrized or table-driven tests over repeated assertions in loops.
- Use shared fixtures and helpers when they exist.
- Assert specific exception types.
- Mock only true external boundaries; use real code, real filesystem, or transactional fixtures for internal behavior.
- Run tests through the project's normal entry point.

## Secrets and environment
- Keep credentials in ignored local env files and update the committed template when adding new variables.
- Never commit secrets, tokens, private keys, DB URLs, or service-account files.
- Read environment variables at the entry point and pass values down.
- Use the project's documented access path for shared infrastructure instead of ad-hoc clients or public endpoints.

## Ask before
- Modifying dependency versions or lockfiles.
- Adding a new dependency.
- Deleting files.
- Deleting or changing existing tests.
- Pushing, force-pushing, or editing CI workflow files.
- Creating authored artifacts on your behalf, including commits, issues, PRs, release notes, or similar records.

A one-time okay only applies to the current task.

When authored artifacts are created, use the user as the author unless they explicitly ask otherwise.

## Large changes
- If a task is broad, cross-cutting, or likely to span many files, pause and clarify the design before coding.
- Focus questions on trade-offs, interfaces, failure modes, and edge cases.
- If the scope is still large after clarification, write down the plan before implementation and continue in a fresh session if needed.

## Default tools
- Use the project's normal task runner and package manager.
- Prefer built-in repo tools over shelling out unnecessarily.
- Prefer editing existing files over creating new ones.

## Don't
- Use review or CI bypasses as shortcuts.
- Extend deprecated or explicitly legacy code paths.
