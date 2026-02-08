# fzf-tab styles for mc

zstyle ':fzf-tab:complete:mc-*' menu yes select
zstyle ':fzf-tab:complete:mc-*' fzf-preview \
  'mc stat ${(Q)word} 2>/dev/null || ls --color=always ${(Q)realpath} 2>/dev/null'
zstyle ':fzf-tab:complete:mc-*' fzf-flags --preview-window=right:60%:wrap