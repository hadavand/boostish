# Boostish Zsh

Opinionated Zsh config with Zinit, fzf, and Powerlevel10k. The repo is split into small, ordered files so you can disable or override pieces easily.

## Features
- Zinit plugin manager with lazy-friendly defaults
- fzf defaults + fzf-tab integration
- Aliases, functions, completions, keybindings, and syntax highlighting
- Optional per-plugin files in `plugins/*/*.plugin.zsh`
- XDG user config files under `${XDG_CONFIG_HOME:-$HOME/.config}/boostish`
- Optional late local override file sourced last

## Requirements
Core:
- zsh, git, curl

Optional (used by some features):
- fzf, bat, lsd, copyq, jq, tree, fd, helm, powerprofilesctl

## Quick start
Clone the repo:
```sh
git clone --depth=1 https://github.com/hadavand/boostish.git ~/.boostish
```

Link `.zshrc` to the example:
```sh
ln -s ~/.boostish/.zshrc ~/.zshrc
```

Or source it from your `.zshrc`:
```sh
printf 'source ~/.boostish/.zshrc\n' > ~/.zshrc
```

Restart the shell:
```sh
exec zsh
```

## File layout
- `00-pre.zsh`: options, env, and Zinit bootstrap
- `10-fzf.zsh`: fzf defaults
- `20-completions.zsh`: completion and fzf-tab styles
- `30-aliases.zsh`: aliases and helper wrappers
- `40-functions.zsh`: helper functions
- `50-highlightings.zsh`: syntax highlighting and autosuggest styles
- `60-keybindings.zsh`: keybindings and ZLE helpers
- `p10k/boostish.zsh`: Boostish Powerlevel10k overlay
- `98-post.zsh`: completions, PATH tweaks, and late init tasks
- `99-local.zsh`: legacy in-repo user overrides (gitignored)

## Early settings (~/.zshenv)
Use `~/.zshenv` only for lightweight variables that must exist before `.zshrc`
loads. Do not run commands, source plugins, or configure interactive behavior
there; `.zshenv` is loaded by every `zsh` process.

Example:
```sh
export CURRENT_USER=majid
export CURRENT_GROUP=majid
```

## Boostish settings
Use this file for user-owned Boostish variables:
```sh
${XDG_CONFIG_HOME:-$HOME/.config}/boostish/settings.zsh
```

It is sourced early, before plugins, aliases, functions, and Powerlevel10k
defaults consume their settings. Keep it lightweight and variable-focused.

Example:
```zsh
typeset -ga BOOSTISH_COMPLETION_COMMANDS=(docker kubectl helm podman volta)
typeset -gA BOOSTISH_COMPLETION_SUBCOMMANDS=([volta]=completions)

typeset -g BOOSTISH_ALIASES_EDITOR="${EDITOR:-vim}"
typeset -g BOOSTISH_PROXY_HTTP="http://127.0.0.1:10808"
typeset -g BOOSTISH_PROXY_SOCKS="socks5h://127.0.0.1:10808"
```

`BOOSTISH_COMPLETION_COMMANDS` defaults to empty, so Boostish does not generate
or source command completions unless you opt in.

Generated completion files are cached under
`${XDG_CACHE_HOME:-$HOME/.cache}/boostish/completions`. Clear them explicitly
after command upgrades or completion changes:
```sh
boostish_clear_completion_cache
boostish_clear_completion_cache kubectl helm
```

## Late local overrides
Use this file for late interactive machine-specific config:
```sh
${XDG_CONFIG_HOME:-$HOME/.config}/boostish/local.zsh
```

It is sourced after Boostish has loaded plugins, functions, completions,
Powerlevel10k, and `98-post.zsh`. Use `settings.zsh` instead if your local
config is just `BOOSTISH_*` variables.

Example:
```zsh
BOOSTISH_SSH_PREFIX='server-'
BOOSTISH_SSH_USER='jack'
boostish_ssh_aliases_from_hosts
```

Legacy `~/.boostish/99-local.zsh` is still supported and is sourced just before
`local.zsh`. If the legacy file was ever added to git, remove it from the index:
```sh
git rm --cached 99-local.zsh
```

## Plugins
Any file matching `plugins/*/*.plugin.zsh` is sourced automatically. Drop your custom plugin snippets there.

## Powerlevel10k
Boostish uses the upstream Powerlevel10k `p10k-rainbow.zsh` and `p10k-pure.zsh`
configs, then applies the small `p10k/boostish.zsh` overlay for regular
terminals. JetBrains and VS Code terminals use upstream Pure.

If you run `p10k configure`, Boostish points Powerlevel10k at this personal
config path outside the repo:
```sh
${XDG_CONFIG_HOME:-$HOME/.config}/boostish/p10k.zsh
```

If this file exists, it is sourced after the upstream Powerlevel10k config and
after `p10k/boostish.zsh`, so it overrides Boostish defaults. `p10k configure`
manages this same file.

## Notes
- User config files are optional; if missing, they are skipped.
- fzf is loaded from `~/.fzf` if you have it installed; otherwise it is pulled via Zinit.
