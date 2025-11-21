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
  --style='full' \
  --layout='reverse' \
  --height='80%' \
  --prompt=' ' \
  --marker=' ' \
  --pointer='󰜴 ' \
  --separator='' \
  --scrollbar='▌' \
  --color='pointer:#4fe8d7' \
  --border='rounded' \
  --border-label=' Completion System ' \
  --input-label=' Query '

  # --height=80% \
  # --color='fg:#91aab0,fg+:#2ecbcb,bg:-1,bg+:#1b3117' \
  # --color='hl:#5ea0f5,hl+:#10b9f2' \
  # --color='info:#7a8288,spinner:#b57bea,header:#7a8288' \
  # --color='prompt:#c68bf9,pointer:#5af2d6,marker:#2bd3be' \
  # --color='border:#262c38,label:#bc03ff,query:#70be56'

zstyle ':fzf-tab:*' fzf-bindings 'space:accept' 'alt-a:toggle-all' 'ctrl-down:toggle+down' 'ctrl-up:toggle+up'
zstyle ':fzf-tab:*' prefix ''
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' show-group full
# zstyle ':fzf-tab:*' single-group prefix
zstyle ':fzf-tab:*' print-query alt-enter
# fzf-min-height 0
FZF_TAB_GROUP_COLORS=(
    $'\033[94m' $'\033[32m' $'\033[33m' $'\033[35m' $'\033[31m' $'\033[38;5;27m' $'\033[36m' \
    $'\033[38;5;100m' $'\033[38;5;98m' $'\033[91m' $'\033[38;5;80m' $'\033[92m' \
    $'\033[38;5;214m' $'\033[38;5;165m' $'\033[38;5;124m' $'\033[38;5;120m'
)
zstyle ':fzf-tab:*' group-colors $FZF_TAB_GROUP_COLORS

# previews
zstyle ':fzf-tab:complete:cd:*'  fzf-preview 'lsd --color=always --group-dirs=first --icon=always $realpath'
zstyle ':fzf-tab:complete:ls*:*' fzf-preview 'lsd --color=always --group-dirs=first --icon=always $realpath'
zstyle ':fzf-tab:complete:kill:*' fzf-preview 'ps -p $word -o pid,user,cmd --no-headers'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

[[ -d $HOME/.zsh/completions ]] || mkdir -p "$HOME/.zsh/completions"

fpath=("$HOME/.zsh/completions" $fpath)

autoload -Uz compinit
compinit -u
