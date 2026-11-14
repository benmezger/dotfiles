# Global instructions

## General
### Communication
- Be maximally brief. No preamble, postamble, or restating what you
  did.
- Answer only what was asked. One-line answers are fine.
- Prose by default; tables for differences and status overviews; lists
  only when clearly better.
- Plain technical explanations; no analogies or stories.
- When asked what needs attention, give only the actionable items, not
  a recap of what's done.

### Accuracy
- Verify before stating facts (read the file, run the command). Never
  guess APIs, flags, or paths.
- If unsure, say so and check.
- Don't assume project structure or conventions; inspect first.
- If the request is ambiguous, ask one short question.
- Before copying legacy behaviour for parity, say whether it's actually
  needed on the platform and flag cases where copying it is harmful.

### Token economy
- Read only the files and line ranges needed; never re-read unchanged files.
- Don't cat whole files when grep or a targeted read works.
- No exploratory commands beyond what the task requires.
- Show only changed code, not full files, when explaining.

### Workflow
- Work on one change at a time and stop after each, so I can commit
  them separately.
- If a task turns out bigger than expected, stop and tell me before
  continuing.
- Before declaring done, run the project's configured linters, type
  checker and tests.
- When a fix doesn't work, say so — don't claim success without
  verifying.

### Git
- Never commit; I commit myself. When a change is ready to commit,
  give me the commit message.
- Commit messages: under 50 characters, imperative, sentence case, no
  semantic/conventional prefix (`feat:`, `fix:`, `chore:` ...), e.g.
  "Skip unreadable existing clusters". PR titles follow the repo's own
  convention.
- Never run git commands that change history or branches: reset,
  rebase, force-push, branch -f, checkout/switch, stash, revert. Give
  me the commands to run instead, after checking that no local commit
  is missing on the remote (compare by patch, not SHA).
- Unset `GITHUB_TOKEN` in the same command as `gh`:
  `unset GITHUB_TOKEN; gh ...`.

## Code
### General
- Minimal change that solves the problem. No unasked refactors; for
  improvements outside the code being changed, suggest instead of
  doing them.
- Follow existing codebase style.
- No comments or docstrings by default; only a short comment for a
  non-obvious why. Never write Args/Returns/Raises-style docstrings
  that restate type hints or obvious behavior, and remove them from
  code you're changing.
- Prefer early returns over nested if/else.
- Separate logical blocks with a blank line: after a loop or `if`
  block, between setup, work and return, and wherever the context
  changes. Don't pack unrelated statements together.
- Single responsibility: functions and methods do one thing. When
  merging or restructuring classes, give each concern its own private
  method and keep public methods to orchestration.
- Use dependency injection where it simplifies testing and
  maintainability.
- Once a change works, simplify the code it touches: reuse existing
  helpers instead of re-implementing them, and drop API calls that
  aren't needed.
- In code being changed, remove unused inputs, flags or parameters,
  but first explain what they did and what still depends on them
  (including callers in other repos).
- No backwards-compat shims or deprecated fallbacks unless asked, or
  unless an external caller still depends on the old interface; say
  which.

### Tests
- One behavior per test; name tests test_<behavior>, not test_1.
- Use fixtures and parametrize instead of repeating setup or
  copy-pasted test variants.
- Test observable behavior, not implementation details. Never test
  private methods/functions (leading underscore); test them through
  the public API.
- Use mock assertion helpers (assert_called_once_with,
  assert_called_with, assert_has_calls, assert_not_called) instead of
  inspecting call_args_list or mock.call_args by index.
- Assert on whole objects, not fields: compare full dataclass/pydantic
  instances against an expected instance (assert result ==
  Expected(...)), not field-by-field (x.name == "a") or by index
  (model.names[0] == "aa"). Build the complete expected object and
  compare once.
- Never weaken or delete a failing test to make it pass — fix the code
  or tell me.

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
- Prefer Pydantic over dataclasses if Pydantic is a project
  dependency.
- Use the project's existing tooling (check pyproject.toml first): its
  formatter, linter, and test runner — don't introduce new ones.
- Run Python commands through the project's package manager, never
  bare `python`, `pytest`, `ruff`, etc. (they may resolve outside the
  project venv):
  - If `uv.lock` exists: `uv run pytest`, `uv run python script.py`
  - If `poetry.lock` exists: `poetry run pytest`, `poetry run python
    script.py`
- No new dependencies without asking.
- No defensive checks for situations that can't occur (hasattr,
  isinstance, None checks on typed params).
- New projects: `uv` for dependencies, `pyright` for type checking,
  `ruff` for linting and formatting, `taskipy` for task commands,
  `pytest` for tests.
