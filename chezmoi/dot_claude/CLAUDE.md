# Global instructions

## General
### Communication
- Be maximally brief. No preamble, postamble, or restating what you
  did.
- Answer only what was asked. One-line answers are fine.
- Plain prose; lists only when clearly better.
- Plain technical explanations; no analogies or stories.
- Use tables for differences and status overviews.
- When asked what needs attention, give only the actionable items, not
  a recap of what's done.

### Accuracy
- Verify before stating facts (read the file, run the command). Never
  guess APIs, flags, or paths.
- If unsure, say so and check.
- Don't assume project structure or conventions; inspect first.
- If the request is ambiguous, ask one short question.

### Token economy
- Read only the files and line ranges needed; never re-read unchanged files.
- Don't cat whole files when grep or a targeted read works.
- No exploratory commands beyond what the task requires.
- Show only changed code, not full files, when explaining.

### Workflow
- Never commit; I commit myself. When a change is ready to commit,
  give me the commit message.
- Commit messages: under 50 characters, imperative, sentence case, no
  semantic/conventional prefix (`feat:`, `fix:`, `chore:` ...), e.g.
  "Skip unreadable existing clusters". PR titles follow the repo's own
  convention.
- Work on one change at a time and stop after each, so I can commit
  them separately.
- Never run git commands that change history or branches: reset,
  rebase, force-push, branch -f, checkout/switch, stash, revert. Give
  me the commands to run instead, after checking that no local commit
  is missing on the remote (compare by patch, not SHA).
- Run `unset GITHUB_TOKEN` before using `gh`.
- If a task turns out bigger than expected, stop and tell me before continuing.
- When a fix doesn't work, say so — don't claim success without verifying.

## Code
### General
- Minimal change that solves the problem. No unasked refactors or comments.
- Follow existing codebase style.
- No docstrings or comments unless asked.
- In tests, use mock assertion helpers (assert_called_once_with,
  assert_called_with, assert_has_calls, assert_not_called) instead of
  inspecting call_args_list or mock.call_args by index.
- Assert on whole objects, not fields: compare full dataclass/pydantic
  instances against an expected instance (assert result ==
  Expected(...)), not field-by-field (x.name == "a") or by index
  (model.names[0] == "aa"). Build the complete expected object and
  compare once.
- Prefer early returns over nested if/else.
- Separate logical blocks with a blank line: after a loop or `if`
  block, between setup, work and return, and wherever the context
  changes. Don't pack unrelated statements together.
- One behavior per test; name tests test_<behavior>, not test_1.
- Use fixtures and parametrize instead of repeating setup or
  copy-pasted test variants.
- Never weaken or delete a failing test to make it pass — fix the code
  or tell me.
- Don't test implementation details; test observable behavior.
- Never test private methods/functions (i.e. leading underscore);
  test them through the public API.
- Never write Args/Returns/Raises/Assumptions-style docstrings that
  restate type hints or obvious behavior; strip them on sight, keeping
  only comments that explain non-obvious why
- Always ensure Single Responsability principle. Functions and methods
  should do one thing and one thing only. When merging or restructuring
  classes, give each concern its own private method and keep public
  methods to orchestration.
- After a change works, look for simplifications: reuse existing
  helpers instead of re-implementing them, and drop API calls that
  aren't needed.
- Remove unused inputs, flags or parameters, but first explain what
  they did and what still depends on them (including callers in other
  repos).
- Before copying legacy behaviour for parity, say whether it's actually
  needed on the platform and flag cases where copying it is harmful.
- Use dependency injection when appropriate if that simplifies
  testing and maintanability.

### Workflows and production safety
- Anything that can write to production needs an explicit dry-run
  path. Test through a dry run and prove it can't write by checking
  every write path, not only the flag.
- When changing a CI workflow, list exactly what differs from the old
  one: job names, inputs, triggers and failure behaviour.

### Python (when working with .py files)
- Always use type hints on function/method signatures, even when
  writing tests.
- Prefer pathlib over os.path, f-strings over format/%.
- Use the project's existing tooling (check pyproject.toml first): its
  formatter, linter, and test runner — don't introduce new ones.
- Run Python commands through the project's package manager, not
  directly:
  - If `uv.lock` exists: `uv run pytest`, `uv run python script.py`
  - If `poetry.lock` exists: `poetry run pytest`, `poetry run python
    script.py`
- Never call bare `python`, `pytest`, `ruff`, etc. as they may resolve
  outside the project venv.
- Run ruff/pytest if configured before declaring done.
- No new dependencies without asking.
- No defensive checks for situations that can't occur (hasattr,
  isinstance, None checks on typed params).
- No backwards-compat shims or deprecated fallbacks unless asked.
- When creating a new project, always use `uv` for dependency
  management.
- When creating a new project, always use `pyright` for type checking.
- When creating a new project, always use `ruff` for code formatting
- When creating a new project, always use `taskipy` to deal with
  formatting, type checking commands.
- When creating a new project, always use `pytest` for running tests.
- Prefer `Pydantic` over `Dataclass` if `Pydantic` is installed as a
  project dependency.
