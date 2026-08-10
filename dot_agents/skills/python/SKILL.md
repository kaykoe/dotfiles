---
name: python
description: Run and manage Python projects with uv-first dependency, environment, command, and test workflows, falling back to pip only when uv is unavailable. Use when working with Python files, pyproject.toml or pyproject.yaml, requirements.txt, virtual environments, Python commands, applications, or tests.
license: MIT
metadata:
  domain: development
  workflow: python-environment
---

# Python Project Skill

## Quick start

1. Work from the project root.
2. Prefer `uv` for every environment, dependency, command, application, and test operation.
3. If `uv` is unavailable, use a local `.venv` and `pip`.
4. Prefer `python3`; use `python` only when `python3` is unavailable.

For a project with `pyproject.toml` or `pyproject.yaml`:

```bash
uv sync
uv run python -m <module>
uv run pytest
```

For a project with `requirements.txt`:

```bash
uv venv
uv pip install -r requirements.txt
uv run python path/to/script.py
uv run pytest
```

## Required workflow

### 1. Select the interpreter only when needed

Use `python3` first and fall back to `python`:

```bash
if command -v python3 >/dev/null 2>&1; then
    python_cmd=python3
elif command -v python >/dev/null 2>&1; then
    python_cmd=python
else
    printf '%s\n' 'Python 3 is required but was not found.' >&2
    exit 1
fi
```

Do not assume `python` points to Python 3.

### 2. Detect the project setup

Use the first matching project configuration:

| Files present | uv workflow |
|---|---|
| `pyproject.toml` or `pyproject.yaml` | Run `uv sync`, then run all commands through `uv run` |
| `requirements.txt` | Run `uv venv`, then `uv pip install -r requirements.txt`; run all commands through `uv run` |
| Neither | Use `uv run` for commands that do not need declared dependencies; create a project configuration only when the task requires dependency management |

If both a `pyproject.*` file and `requirements.txt` exist, use the `pyproject.*` workflow unless the project documentation explicitly says that `requirements.txt` is authoritative.

### 3. Use uv when available

Check for `uv` before choosing the fallback:

```bash
if command -v uv >/dev/null 2>&1; then
    uv_available=true
else
    uv_available=false
fi
```

With `pyproject.toml` or `pyproject.yaml`, use standard uv project commands:

```bash
uv sync
uv run python -m package_name
uv run pytest
```

With `requirements.txt`, initialize and populate the environment in this order:

```bash
uv venv
uv pip install -r requirements.txt
uv run python path/to/script.py
uv run pytest
```

Always prefix Python commands, application launches, linters, formatters, and tests with `uv run` when uv is available. Examples include `uv run python`, `uv run pytest`, `uv run ruff`, and `uv run mypy`.

### 4. Fall back to pip only when uv is unavailable

When `uv` is not installed, first create the environment with Python 3, preferring `python3`:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

If `python3` is unavailable, use `python` instead:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

After activation, run Python commands, applications, and tests using the environment's executables. Do not use `uv run` in this fallback path:

```bash
python -m package_name
pytest
ruff check .
mypy .
```

For a project with only `pyproject.toml` or `pyproject.yaml`, install the project after creating and activating `.venv` with the package manager supported by its metadata, normally:

```bash
pip install -e .
```

Do not install both uv-managed and pip-managed environments unless the project explicitly requires that separation.

## Command rules

- Never run a project Python command directly with a system interpreter when uv is available; use `uv run`.
- Never use pip as the first choice; pip is fallback-only.
- Keep `.venv` local to the project and do not commit it.
- Read the project README, `pyproject.*`, and test configuration before changing dependency versions or test commands.
- Run the narrowest relevant test or check immediately after each change, then run the broader suite when practical.
- Avoid `sudo pip`; use a project environment instead.

## Worked examples

### uv project

```bash
uv sync
uv run pytest tests/test_parser.py
uv run python -m myapp --help
```

### requirements.txt project

```bash
uv venv
uv pip install -r requirements.txt
uv run python app.py
uv run pytest
```

### No uv available

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
pytest
python app.py
```

If `python3` is unavailable, replace it with `python` in the environment creation command.
