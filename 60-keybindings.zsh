bindkey -e
bindkey '^[[Z' backward-menu-complete

# Keybindings (override plugin defaults)
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

bindkey -M viins '^[[H' beginning-of-line
bindkey -M viins '^[[F' end-of-line

bindkey '\e[1;5D' backward-word   # Ctrl+Left
bindkey '\e[1;5C' forward-word    # Ctrl+Right

# Pattern-only search
unsetopt flowcontrol
bindkey '^S' history-incremental-pattern-search-forward

bindkey -s '^X^Z' ' exec zsh^M'
bindkey -s '^[^L' ' /usr/bin/clear^M'

bindkey '^ ' autosuggest-accept
bindkey '^\' autosuggest-clear

# Quality of Life :)
sudo-command-line() {
  zle autosuggest-clear
  [[ -z $BUFFER ]] && zle up-history
  if [[ $BUFFER == sudo\ * ]]; then
    BUFFER=${BUFFER#sudo }
  else
    BUFFER="sudo $BUFFER"
  fi
  CURSOR=${#BUFFER}
  zle autosuggest-fetch
  zle redisplay
}
zle -N sudo-command-line
bindkey '!!' sudo-command-line

expand-alias-clean() {
  zle autosuggest-clear
  zle _expand_alias
  zle autosuggest-fetch
  zle redisplay
}
zle -N expand-alias-clean
bindkey '^[e' expand-alias-clean

# Up/Down: search history by current prefix
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=#00af5f,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_TIMEOUT=1

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down
bindkey '^Z' undo

boostish-copy-buffer() {
  if ! _boostish_copyq_available; then
    zle -M "copyq not found"
    return 1
  fi

  if ! printf "%s" "$BUFFER" | _boostish_copyq add - || ! _boostish_copyq select 0; then
    zle -M "clipboard unavailable"
    return 1
  fi
}
zle -N boostish-copy-buffer
bindkey '^X^Y' boostish-copy-buffer

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

boostish-abort-line() {
  BUFFER=""
  CURSOR=0
  zle reset-prompt
}
zle -N boostish-abort-line
bindkey '^G' boostish-abort-line
