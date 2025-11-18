zstyle ':completion:*' menu no
zstyle ':completion:*' completer _expand _complete _ignored _prefix _extensions
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'm:{-_}={_-}'
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' rehash true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-compctl false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' group-name ''
[[ -f ~/.LS_COLORS ]] && eval "$(dircolors -b ~/.LS_COLORS)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' accept-exact-dirs true
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':completion:*:git-checkout:*' sort false

zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,args -w -w"
zstyle ':completion:*:*:kill:*:processes' command 'ps -u $USER -o pid,%cpu,cputime,cmd'

# zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

zstyle ':fzf-tab:*' fzf-flags \
  --style=default \
  --layout=reverse \
  --height=80% \
  --prompt=' ' \
  --marker=' ' \
  --pointer=' ' \
  --separator='─' \
  --scrollbar='▌' \
  --color='fg:#91aab0,fg+:#2ecbcb,bg:-1,bg+:#1b3117' \
  --color='hl:#5ea0f5,hl+:#10b9f2' \
  --color='info:#7a8288,spinner:#b57bea,header:#7a8288' \
  --color='prompt:#c68bf9,pointer:#5af2d6,marker:#2bd3be' \
  --color='border:#262c38,label:#bc03ff,query:#70be56'

zstyle ':fzf-tab:*' switch-group '<' '>'

[[ -d $HOME/.zsh/completions ]] || mkdir -p "$HOME/.zsh/completions"

fpath=("$HOME/.zsh/completions" $fpath)

autoload -Uz compinit
compinit -u

if command -v docker >/dev/null 2>&1; then
    source <(docker completion zsh)
fi

if command -v k9s >/dev/null 2>&1; then
    source <(k9s completion zsh)
fi
