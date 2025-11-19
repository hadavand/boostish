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

bindkey -s '^Xz' 'exec zsh^M'
bindkey -s '^[^L' '/usr/bin/clear^M'

bindkey '^ ' autosuggest-accept
bindkey '^\' autosuggest-clear

# Quality of Life :)
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

# Up/Down: search history by current prefix
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=#00af5f,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_TIMEOUT=1

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# copybuffer () {
#   if builtin which clipcopy &>/dev/null; then
#     printf "%s" "$BUFFER" | clipcopy
#   else
#     zle -M "clipcopy not found. Please make sure you have Oh My Zsh installed correctly."
#   fi
# }

# zle -N copybuffer

# bindkey -M emacs "^O" copybuffer
# bindkey -M viins "^O" copybuffer
# bindkey -M vicmd "^O" copybuffer
