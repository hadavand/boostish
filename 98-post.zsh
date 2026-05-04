#typeset -ga zle_highlight
#zle_highlight+=('paste:none')

if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
fi

if (( $+commands[docker] )); then
  source <(docker completion zsh)
fi

if (( $+commands[kubectl] )); then
  source <(kubectl completion zsh)
fi

if (( $+commands[oc] )); then
  source <(oc completion zsh)
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
  source <(helm completion zsh)
fi

if [[ -n "$TILIX_ID" || -n "$VTE_VERSION" ]]; then
  [[ -r /etc/profile.d/vte.sh ]] && source /etc/profile.d/vte.sh
fi
