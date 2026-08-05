---
name: shell-validation
description: Validate Bash and Zsh shell files after changes, using ShellCheck when available and syntax checks otherwise.
---

For every modified shell file, run validation before finishing.

1. Use `shellcheck <file>` when ShellCheck is available.
2. If ShellCheck is unavailable, select the syntax checker from the file shebang. Use `bash -n <file>` for Bash, `zsh -n <file>` for Zsh, and `bash -n <file>` when the shell cannot be determined.
3. Tell the user that ShellCheck was unavailable and that syntax-only validation was used.
4. Report lint or syntax failures, and fix failures caused by the current change.
5. Do not run shell files as part of validation.
