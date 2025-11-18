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

# Up/Down: search history by current prefix
bindkey '^[[A' history-beginning-search-backward   # Up arrow
bindkey '^[[B' history-beginning-search-forward    # Down arrow

# Pattern-only search
unsetopt flowcontrol
bindkey '^S' history-incremental-pattern-search-forward

bindkey -s '^Xz' 'exec zsh^M'
bindkey -s '^[^L' '/usr/bin/clear^M'

bindkey '^ ' autosuggest-accept
bindkey '^\' autosuggest-clear

autoload -Uz edit-command-line; zle -N edit-command-line; bindkey '^X^E' edit-command-line

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
bindkey '@@' expand-alias-clean
