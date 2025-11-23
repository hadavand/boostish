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
sudo-command-line(){ zle autosuggest-clear; [[ -z $BUFFER ]] && zle up-history; [[ $BUFFER == sudo\ * ]] && BUFFER=${BUFFER#sudo } || BUFFER="sudo $BUFFER"; CURSOR=${#BUFFER}; zle autosuggest-fetch; zle redisplay; }
zle -N sudo-command-line
bindkey '!!' sudo-command-line

expand-alias-clean() {
  zle autosuggest-clear
  zle _expand_alias
  zle autosuggest-fetch
  zle redisplay
}
zle -N expand-alias-clean
bindkey '^[@' expand-alias-clean

# Up/Down: search history by current prefix
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=#00af5f,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_TIMEOUT=1

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down
bindkey '^Z' undo

boostish-copy-buffer () {
  if builtin which copyq &>/dev/null; then
    printf "%s" "$BUFFER" | copyq add - && copyq select 0
  else
    zle -M "copyq not found"
  fi
}
zle -N boostish-copy-buffer
bindkey '^X^Y' boostish-copy-buffer

autoload -Uz bracketed-paste-magic edit-command-line
zle -N bracketed-paste bracketed-paste-magic
zle -N edit-command-line
bindkey '^X^E' edit-command-line

boostish-paste() {
  local text
  text=$(copyq clipboard 2>/dev/null) || return
  [[ -z $text ]] && return
  text=${text%$'\n'}
  LBUFFER+="$text"
}
zle -N boostish-paste
bindkey '^X^V' boostish-paste

boostish-abort-line() {
  BUFFER=""
  CURSOR=0
  zle reset-prompt
}
zle -N boostish-abort-line
bindkey '^G' boostish-abort-line
