# plain shell on linux virtual consoles (tty2..tty6)
if [[ $TTY == /dev/tty[1-6] ]]; then
  PROMPT='%n@%m:%~ %# '
  return 0
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

BOOSTISH_CONFIG_DIR="$HOME/.boostish"; export BOOSTISH_CONFIG_DIR

export BOOSTISH_PRE_FILE="$BOOSTISH_CONFIG_DIR/00-pre.zsh"
[[ -f $BOOSTISH_PRE_FILE ]] && source "$BOOSTISH_PRE_FILE"

# Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Zinit completion
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Essential Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-rust

# Plugins --------------------
zinit ice depth=1; zinit light zsh-users/zsh-autosuggestions
zinit ice depth=1; zinit light zsh-users/zsh-history-substring-search
zinit ice depth=1; zinit light Aloxaf/fzf-tab
# zinit ice depth=1; zinit light MichaelAquilina/zsh-you-should-use
# zinit ice depth=1; zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice depth=1; zinit light zsh-users/zsh-syntax-highlighting
zinit ice depth=1; zinit light zsh-users/zsh-completions

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::bgnotify
zinit snippet OMZP::encode64
zinit snippet OMZP::gh

export BOOSTISH_COMPLETIONS_FILE="$BOOSTISH_CONFIG_DIR/20-completions.zsh"
[[ -r $BOOSTISH_COMPLETIONS_FILE ]] && source "$BOOSTISH_COMPLETIONS_FILE"

zinit ice lucid; zinit snippet ~/.boostish/plugins/minio/minio.plugin.zsh

export BOOSTISH_ALIASES_FILE="$BOOSTISH_CONFIG_DIR/30-aliases.zsh"
[[ -r $BOOSTISH_ALIASES_FILE ]] && source "$BOOSTISH_ALIASES_FILE"

export BOOSTISH_FUNCTIONS_FILE="$BOOSTISH_CONFIG_DIR/40-functions.zsh"
[[ -r $BOOSTISH_FUNCTIONS_FILE ]] && source "$BOOSTISH_FUNCTIONS_FILE"

export BOOSTISH_SETTINGS_FILE="$BOOSTISH_CONFIG_DIR/settings.zsh"
[[ -r $BOOSTISH_SETTINGS_FILE ]] && source "$BOOSTISH_SETTINGS_FILE"

export BOOSTISH_HIGHLIGHTINGS_FILE="$BOOSTISH_CONFIG_DIR/50-highlightings.zsh"
[[ -r $BOOSTISH_HIGHLIGHTINGS_FILE ]] && source "$BOOSTISH_HIGHLIGHTINGS_FILE"

export BOOSTISH_KEYBINDINGS_FILE="$BOOSTISH_CONFIG_DIR/60-keybindings.zsh"
[[ -r $BOOSTISH_KEYBINDINGS_FILE ]] && source "$BOOSTISH_KEYBINDINGS_FILE"

# Powerlevel10k (with different configs per terminal)
zinit ice depth=1; zinit light romkatv/powerlevel10k

if [[ "$TERMINAL_EMULATOR" == "JetBrains-JediTerm" || -n "$VSCODE_INTEGRATED_TERMINAL" || "$TERM_PROGRAM" == "vscode" ]]; then
  export BOOSTISH_POWER_LEVEL_FILE="$BOOSTISH_CONFIG_DIR/91-p10k-pure.zsh"
else
  export BOOSTISH_POWER_LEVEL_FILE="$BOOSTISH_CONFIG_DIR/90-p10k.zsh"
fi

[[ -r $BOOSTISH_POWER_LEVEL_FILE ]] && source "$BOOSTISH_POWER_LEVEL_FILE"

export BOOSTISH_POST_FILE="$BOOSTISH_CONFIG_DIR/99-post.zsh"
[[ -r $BOOSTISH_POST_FILE ]] && source "$BOOSTISH_POST_FILE"

alias mcli='docker compose exec minio-client mc'
