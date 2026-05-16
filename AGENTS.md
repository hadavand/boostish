# AGENTS.md

Guidance for coding agents working on Boostish.

## Project Overview

Boostish is an opinionated Zsh configuration. It is loaded from `.zshrc`, split
into ordered files, and intended to stay easy to disable, override, or inspect.

The main load order is:

1. `.zshrc`
2. optional `${XDG_CONFIG_HOME:-$HOME/.config}/boostish/settings.zsh`
3. `00-pre.zsh`
4. `20-completions.zsh`
5. Zinit-managed plugins and `plugins/*/*.plugin.zsh`
6. `30-aliases.zsh`
7. `40-functions.zsh`
8. optional legacy `settings.zsh`
9. `50-highlightings.zsh`
10. `60-keybindings.zsh`
11. Powerlevel10k config, `p10k/boostish.zsh`, and user `p10k.zsh`
12. `98-post.zsh`
13. `99-local.zsh`
14. optional `${XDG_CONFIG_HOME:-$HOME/.config}/boostish/local.zsh`

## File Ownership

- Keep startup behavior in the numbered root files that match the existing
  responsibility described in `README.md`.
- Put reusable shell helpers in `40-functions.zsh`.
- Put aliases and small command wrappers in `30-aliases.zsh`.
- Put completion setup in `20-completions.zsh` and custom completion functions
  in `_completions/`.
- Put optional feature bundles in `plugins/<name>/<name>.plugin.zsh`; these are
  auto-sourced by `.zshrc`.
- Do not edit `99-local.zsh`, `settings.zsh`, or user config under
  `${XDG_CONFIG_HOME:-$HOME/.config}/boostish/` unless the user explicitly asks.

## Zsh Style

- Use Zsh syntax deliberately; do not rewrite code to POSIX `sh` unless the file
  is actually meant to run under `sh`.
- Prefer `[[ ... ]]`, arrays, associative arrays, parameter expansion, and
  `(( ... ))` where they are already the natural fit.
- Guard optional external commands with `(( $+commands[name] ))` or
  `command -v name >/dev/null 2>&1` before wiring aliases, completions, or
  integrations.
- Prefix internal helper functions and globals with `_boostish_` or a
  feature-specific prefix to avoid polluting the interactive namespace.
- Use `typeset -g` or `typeset -gA` for intentional global shell state.
- Preserve existing UTF-8 prompt/fzf glyphs when editing related files. For new
  prose and comments, prefer plain ASCII unless matching nearby text requires
  otherwise.

## Behavioral Rules

- Keep shell startup fast. Avoid expensive command execution at source time,
  especially network calls, package manager calls, recursive scans, or commands
  that can block.
- Do not make Zinit download more plugins unless the user asked for that feature
  and the dependency is justified.
- Respect local overrides: committed defaults should be safe and generic, while
  machine-specific values belong under
  `${XDG_CONFIG_HOME:-$HOME/.config}/boostish/`.
- Avoid changing keybindings, global aliases, prompt behavior, proxy defaults, or
  history behavior incidentally. These are high-impact interactive surfaces.
- For generated completions cached by `98-post.zsh`, keep cache paths under
  `${XDG_CACHE_HOME:-$HOME/.cache}/boostish/`.

## Validation

There is no formal test suite. Before finishing shell changes, run syntax checks:

```sh
for f in .zshrc [0-9][0-9]-*.zsh p10k/*.zsh plugins/*/*.plugin.zsh _completions/_*; do
  zsh -n "$f" || exit 1
done
```

When changing load order, plugin behavior, completions, aliases, or functions,
also test in a disposable shell if dependencies are available:

```sh
zsh -fic 'source ./.zshrc; echo boostish-loaded'
```

If interactive testing is skipped because local dependencies, network, or user
machine state would make it unreliable, say that explicitly in the final note.

## Git Hygiene

- Check `git status --short` before and after edits.
- Leave unrelated user changes alone.
- Do not commit local-only files, generated completion caches, Zinit downloads,
  or personal Powerlevel10k output.
