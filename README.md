# Boostish Zsh

Opinionated Zsh config with Zinit, fzf, and Powerlevel10k. The repo is split into small, ordered files so you can disable or override pieces easily.

## Features
- Zinit plugin manager with lazy-friendly defaults
- fzf defaults + fzf-tab integration
- Aliases, functions, completions, keybindings, and syntax highlighting
- Optional per-plugin files in `plugins/*/*.plugin.zsh`
- Local override file sourced last (`99-local.zsh`)

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
- `99-local.zsh`: user overrides (sourced last; gitignored)

## Local overrides (99-local.zsh)
`99-local.zsh` is sourced last and is not committed. Use it for machine-specific config.

Example:
```sh
# User overrides (sourced last).
# Put machine or user-specific settings here.

BOOSTISH_SSH_PREFIX='server-'
BOOSTISH_SSH_USER='jack'
boostish_ssh_aliases_from_hosts
```

If the file was ever added to git, remove it from the index:
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

## Notes
- `settings.zsh` is optional; if missing it is skipped.
- fzf is loaded from `~/.fzf` if you have it installed; otherwise it is pulled via Zinit.
