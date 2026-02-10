#typeset -ga zle_highlight
#zle_highlight+=('paste:none')

if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
fi

if (( $+commands[docker] )); then
  source <(docker completion zsh)
fi

if (( $+commands[k9s] )); then
  source <(k9s completion zsh)
fi

if (( $+commands[volta] )); then
  source <(volta completions zsh)
fi

if (( $+commands[codex] )); then
  source <(codex completion zsh)
fi

if (( $+commands[helm] )); then
  : ${ZSH_CACHE_DIR:="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"}
  if [[ ! -d "$ZSH_CACHE_DIR/completions" ]]; then
    mkdir -p "$ZSH_CACHE_DIR/completions"
  fi
  # If the completion file does not exist, generate it and then source it
  # Otherwise, source it and regenerate in the background
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_helm" ]]; then
    helm completion zsh | tee "$ZSH_CACHE_DIR/completions/_helm" >/dev/null
    source "$ZSH_CACHE_DIR/completions/_helm"
  else
    source "$ZSH_CACHE_DIR/completions/_helm"
    helm completion zsh | tee "$ZSH_CACHE_DIR/completions/_helm" >/dev/null &|
  fi
fi

if [[ -n "$TILIX_ID" || -n "$VTE_VERSION" ]]; then
  [[ -r /etc/profile.d/vte.sh ]] && source /etc/profile.d/vte.sh
fi
