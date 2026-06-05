bindkey -e                                      # Use Emacs-style editing keys
bindkey '^[[Z' backward-menu-complete           # Shift+Tab cycles completion menu backward

# Keybindings (override plugin defaults)
bindkey '^A' beginning-of-line                  # Ctrl+A moves to start of line
bindkey '^E' end-of-line                        # Ctrl+E moves to end of line

bindkey '^[[H' beginning-of-line                # Home moves to start of line
bindkey '^[[F' end-of-line                      # End moves to end of line

bindkey -M viins '^[[H' beginning-of-line       # Home in vi insert mode
bindkey -M viins '^[[F' end-of-line             # End in vi insert mode

bindkey '\e[1;5D' backward-word   # Ctrl+Left
bindkey '\e[1;5C' forward-word    # Ctrl+Right

# Pattern-only search
unsetopt flowcontrol
bindkey '^S' history-incremental-pattern-search-forward  # Ctrl+S searches history forward

bindkey -s '^X^Z' ' exec zsh^M'                 # Ctrl+X Ctrl+Z restarts the shell
bindkey -s '^[^L' ' /usr/bin/clear^M'           # Alt+Ctrl+L clears the screen without history

bindkey '^ ' autosuggest-accept                 # Ctrl+Space accepts autosuggestion
bindkey '^\' autosuggest-clear                  # Ctrl+\ clears autosuggestion

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
bindkey '!!' sudo-command-line                  # !! toggles sudo on the current command

expand-alias-clean() {
  zle autosuggest-clear
  zle _expand_alias
  zle autosuggest-fetch
  zle redisplay
}
zle -N expand-alias-clean
bindkey '^[e' expand-alias-clean                # Alt+E expands aliases in the buffer

# Up/Down: search history by current prefix
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=#00af5f,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_TIMEOUT=1

bindkey '^[[A' history-substring-search-up      # Up searches older history by prefix
bindkey '^[[B' history-substring-search-down    # Down searches newer history by prefix
bindkey '^[OA' history-substring-search-up      # Alternate Up sequence
bindkey '^[OB' history-substring-search-down    # Alternate Down sequence
bindkey '^Z' undo                               # Ctrl+Z undoes the last edit

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
bindkey '^X^Y' boostish-copy-buffer             # Ctrl+X Ctrl+Y copies buffer to clipboard

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line                # Ctrl+X Ctrl+E edits command in $EDITOR

boostish-abort-line() {
  BUFFER=""
  CURSOR=0
  zle reset-prompt
}
zle -N boostish-abort-line
bindkey '^G' boostish-abort-line                # Ctrl+G clears the current line
