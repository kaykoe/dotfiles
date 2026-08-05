# Repository Guide

## Purpose and layout

This is a [ChezMoi](https://www.chezmoi.io/) source repository for a personal dotfiles setup, not an application with a conventional build or test suite. ChezMoi maps source names to home-directory targets: `dot_*` becomes a dotfile, `private_dot_*` becomes a private dotfile/directory, and `executable_*` marks deployed scripts executable.

- `.chezmoi.yaml.tmpl` is the root configuration. It derives `osid` and WSL/laptop state, then prompts once for email, privilege, shell, GUI, editor, and feature choices. Its `data` values control most template conditionals.
- `.chezmoidata/packages.yaml` is the package matrix. It combines common groups with OS-specific `cli`, `gui`, `winapps`, `steam`, `laptop`, and `uninstall` lists.
- `.chezmoiscripts/` contains lifecycle scripts. Prefixes determine execution semantics: `run_before_*` runs before applying files, `run_onchange_*` reruns when its rendered content changes, `run_once_*` runs once, and `run_uninstall_*` runs on removal.
- `private_dot_config/` holds application configuration. The primary coordinated desktop stack is Hyprland, Waybar, Rofi, SwayNC, Kitty, and Wallust. Neovim uses a LazyVim configuration under `private_dot_config/nvim/`.
- `.chezmoiexternal.yaml` declares externally managed downloaded files. Do not convert those into tracked copies unless intentionally changing the refresh model.
- `.chezmoiignore` is itself templated and excludes features that do not match the machine choices. Files ignored there are not applied.

## Essential workflow

Run commands from the repository root.

```bash
# Inspect the generated target-state difference before changing a machine.
chezmoi diff

# Apply the full rendered source state to the home directory.
chezmoi apply

# Apply one source target while iterating on it.
chezmoi apply <target>

# Inspect what ChezMoi currently manages.
chezmoi managed
```

`chezmoi apply` is stateful and can run privileged installation/service scripts. Prefer `chezmoi diff` first. Use a temporary ChezMoi state/configuration when validating changes that would otherwise prompt for machine-specific data or alter the current host. This repository has no observed automated test or lint command.

## Template and configuration rules

- Treat every `*.tmpl` file as a Go template rendered by ChezMoi, not plain shell/config text. Preserve template delimiters and whitespace trimming (`{{-` / `-}}`), because rendered shell command layout depends on them.
- Add new machine-dependent behavior through the existing data fields and `.chezmoiignore` gates. Keep shell, GUI, and optional-tool behavior conditional rather than assuming the author’s workstation.
- Package installation supports only the observed OpenSUSE Tumbleweed and Debian/Ubuntu branches. The package script selects `zypper` or `apt`; changes to package lists must use package names appropriate to those branches.
- Keep `run_onchange_*` scripts deterministic. The Kanata scripts deliberately embed a source-file hash so changing `config.kbd` or `kanata.service` triggers redeployment.
- The root files `config.kbd` and `kanata.service` are not deployed to `$HOME`; they are copied by lifecycle scripts into `/etc/kanata` and `/etc/systemd/system` respectively. They remain ignored as normal home targets.
- Scripts that install packages, modify `/etc`, manage systemd, or compile Hyprland plugins require the corresponding host tools and usually `sudo`. Do not execute them casually during static validation.

## Desktop configuration flow

Hyprland loads `private_dot_config/hypr/hyprland.conf`, which in turn sources `configs/Keybinds.conf`, then the `UserConfigs/` files, then `monitors.conf` and `workspaces.conf`. Put user-facing Hyprland changes in the appropriate `UserConfigs/` file unless changing the base composition intentionally.

Wallust produces Kitty and Neopywal color outputs from its templates. Its configured Kitty target is `~/.config/kitty/kitty-themes/01-Wallust.conf`; that generated output is ignored by ChezMoi, so do not edit the deployed generated file as source of truth. The checked-in template lives under `private_dot_config/wallust/templates/`.

The Hyprbars `run_onchange` script derives the installed Hyprland version, resets or updates a cached upstream plugin checkout, selects a matching commit from `hyprpm.toml`, builds it, and replaces the installed `.so`. It has network, compiler, and session dependencies.

## Style and editing conventions

- `.editorconfig` requires UTF-8, LF endings, a final newline, and tab indentation repository-wide. Match the surrounding file, especially in shell, Lua, TOML, YAML, and template blocks.
- Existing shell scripts use Bash, `set -e` for failure-sensitive operations, `on_path` helpers for idempotent installation, and `pushd`/`popd` cleanup traps around temporary directories. Preserve these patterns when extending scripts.
- Shell startup files maintain ordering-sensitive initialization. In particular, Zoxide initialization is explicitly last in both shell configurations; do not move later statements below it without verifying interactive startup behavior.
- Neovim plugin customizations are separate Lua modules in `private_dot_config/nvim/lua/plugins/`, while bootstrap/options/keymaps/autocmds live in `lua/config/`. Keep plugin overrides modular rather than expanding `init.lua`.

## Safety checks

Before editing a template or lifecycle script, review both its condition in `.chezmoiignore` and the relevant data fields in `.chezmoi.yaml.tmpl`. After changes, inspect `git diff --check` and a targeted `chezmoi diff` in an appropriate configured ChezMoi environment. Do not commit generated runtime artifacts such as Wallust outputs, Btop logs, Yazi plugins, or wallpaper state; they are explicitly ignored.
