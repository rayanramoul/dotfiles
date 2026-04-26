# User-level preferences

These apply across all projects. When a project has its own `CLAUDE.md`, `AGENTS.md`, or `.cursor/rules/*`, defer to the project's instructions where they conflict.

## Code quality rules (universal)
- **DRY where it reduces complexity** — three similar lines are fine; the same block repeated across modules is not.
- **Consolidate shared types** — when the same shape (dataclass, `TypedDict`, `Protocol`, Pydantic / Zod / equivalent model) appears in more than one module, move it to a common location and import it. Don't redefine equivalent types locally.
- **No dead code** — grep before deleting to confirm no callers (include configs, scripts, entry points, tests).
- **No circular imports** — extract the shared piece into a lower-level module rather than patching with local imports or conditional-import workarounds.
- **No weak types** — `Any`, untyped `dict` / `list`, bare `object`, or blanket type-suppressions need a written one-line justification.
- **No defensive try/except** — only catch at real boundaries (user input, external APIs, filesystem, network, subprocess) with a concrete handling strategy. Never swallow exceptions. Never silent fallback.
- **One code path** — remove deprecated / legacy / "just in case" branches; don't keep both.
- **No AI slop comments** — no narrating in-motion work, no "was X, now Y", no restating what the code already says. Comments only for non-obvious *why* (constraints, invariants, workarounds).

## Code style (typed languages)
- Every function is typed. Use modern type syntax for the language: in Python prefer `| None` over `Optional`, `list[T]` / `dict[K, V]` over `List` / `Dict`, `|` unions over `Union`. In TypeScript prefer discriminated unions and `readonly` where applicable.
- Docstrings / JSDoc only when they add information beyond the signature (constraints, invariants, error contract). No padding. No restating the parameter list.
- Line length and formatter rules follow the project's existing config (`ruff.toml`, `.prettierrc`, `rustfmt.toml`, …). Never reformat against the configured style.
- Caching (`@functools.cache`, `useMemo`, memoization wrappers) is opt-in for measured hot paths, not a default.

## Testing
- Mirror the source layout under `tests/` (or the project's convention). Match the project's file/function naming.
- Prefer parametrized / table-driven tests (`@pytest.mark.parametrize`, `it.each`, `t.Run` with subtests) over loops with multiple assertions.
- Use the project's shared fixtures / helpers — don't invent your own DB, RNG, or HTTP mocks when canonical ones exist.
- Exception assertions are **specific** (`pytest.raises(SpecificError)`, `expect(...).toThrow(SpecificError)`), never bare `Exception` / `Error`.
- Mock at **real external boundaries only** (third-party HTTP APIs, payment providers, paid services). Don't mock the project's own database, filesystem, or domain code — use the real thing through a transactional or sandbox fixture.
- Run tests through the project's runner (`just test`, `npm test`, `cargo test`, `go test`), not by re-deriving the invocation.

## Secrets & environment
- Real credentials live in a gitignored env file (`.env`, `conf.env`, `.envrc.local`, …). Update the committed template (`.env.example`, `conf.env.template`) when introducing a new variable.
- Never commit secrets, service-account JSONs, API tokens, DB URLs, or keypairs. Treat anything matching `*creds*`, `*-key*`, `*.pem`, `*service-account*.json` as sensitive — refuse to add or print.
- Read env vars at the entry point (`main`, the CLI handler, the request handler) and pass values down. Avoid reading `os.environ` / `process.env` deep in library code.
- For shared infra access, use the project's documented proxy / tunnel scripts rather than direct public IPs or hand-rolled clients.

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
- **Short global rule** (tool or style preference that applies everywhere) → add it to `~/.claude/CLAUDE.md` (or `~/.config/opencode/AGENTS.md` for opencode).
- **Multi-step or task-specific workflow with steps / arguments / side effects** → create a skill at `.claude/skills/<name>/SKILL.md` (Claude Code) or a command at `~/.config/opencode/command/<name>.md` (opencode), with `name` and `description` frontmatter. Add `disable-model-invocation: true` when the flow should only run on an explicit `/<name>` invocation, not auto-applied.

Do not edit any rule file or create skills without explicit confirmation.

## Default tool preferences
- Use the project's existing task runner (`just`, `make`, `npm run …`, `bun run …`, `cargo`, `go`) over ad-hoc shell invocations.
- Use the project's existing package / dependency manager. Never introduce a new one without asking.
- Use the project's existing linter / formatter / type-checker — don't re-do their job manually. If one is configured but not running, ask before changing its config.
- Prefer built-in tools (`Read` / `Edit` / `Grep` / `Glob`) over shelling out to `cat` / `sed` / `awk` / `find` / `grep`.
- Prefer editing existing files over creating new ones. Don't create documentation files (`*.md`, `README*`) unless explicitly asked.

## Don't
- Bypass code review or CI as a shortcut. Commit prefixes / flags that skip checks (`[skip ci]`, `--no-verify`, `exp-` prefixes that bypass pipelines, …) are for the situations they were designed for, not for getting a quick green.
- Extend code paths the project has explicitly marked as deprecated or `legacy_` / `*_deprecated/`. Migrate or refuse, don't grow them.
