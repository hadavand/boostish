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
if [[ -f ~/.LS_COLORS ]]; then
  eval "$(dircolors -b ~/.LS_COLORS)"
fi
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*:git-checkout:*' sort false

zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,args -w -w"
zstyle ':completion:*:*:kill:*:processes' command 'ps -u $USER -o pid,%cpu,cputime,cmd'

# zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

zstyle ':fzf-tab:*' fzf-flags \
  --layout='reverse' \
  --height='80%' \
  --prompt='  ' \
  --marker=' ' \
  --pointer='󰛂 ' \
  --separator='─' \
  --scrollbar='│' \
  --info='right' \
  --color='fg:#d0d0d0,fg+:#d0d0d0,bg:-1,bg+:#414a59' \
  --color='hl:#5f87af,hl+:#5fd7ff,info:#0fc38a,marker:#30f70c' \
  --color='prompt:#0cb7e6,spinner:#af5fff,pointer:#0de36a,header:#0fc38a' \
  --color='border:#262626,label:#aeaeae,query:#d9d9d9' \
  --preview-window='border-rounded'

zstyle ':fzf-tab:*' fzf-bindings \
  'space:accept' \
  'alt-a:toggle-all' \
  'ctrl-down:toggle+down' \
  'ctrl-up:toggle+up'
zstyle ':fzf-tab:*' prefix ''
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' show-group full
# zstyle ':fzf-tab:*' single-group prefix
zstyle ':fzf-tab:*' print-query alt-enter
# fzf-min-height 0
FZF_TAB_GROUP_COLORS=(
  $'\033[94m'
  $'\033[32m'
  $'\033[33m'
  $'\033[35m'
  $'\033[31m'
  $'\033[38;5;27m'
  $'\033[36m'
  $'\033[38;5;100m'
  $'\033[38;5;98m'
  $'\033[91m'
  $'\033[38;5;80m'
  $'\033[92m'
  $'\033[38;5;214m'
  $'\033[38;5;165m'
  $'\033[38;5;124m'
  $'\033[38;5;120m'
)
zstyle ':fzf-tab:*' group-colors $FZF_TAB_GROUP_COLORS

# previews
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always --group-dirs=first --icon=always $realpath'
zstyle ':fzf-tab:complete:ls*:*' fzf-preview 'lsd --color=always --group-dirs=first --icon=always $realpath'
zstyle ':fzf-tab:complete:kill:*' fzf-preview 'ps -p $word -o pid,user,cmd --no-headers'
zstyle ':fzf-tab:complete:sudo:*' fzf-preview '(( ${words[(I)systemctl]} )) && SYSTEMD_COLORS=1 SYSTEMD_PAGER=cat systemctl --no-pager --full --plain status -- ${(Q)word} 2>&1 | sed -n "1,200p"'
zstyle ':fzf-tab:complete:systemctl:*' fzf-preview 'SYSTEMD_COLORS=1 SYSTEMD_PAGER=cat systemctl --no-pager --full --plain status -- ${(Q)word} 2>&1 | sed -n "1,200p"'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 SYSTEMD_PAGER=cat systemctl --no-pager --full --plain status -- ${(Q)word} 2>&1 | sed -n "1,200p"'

fpath=("$BOOSTISH_CONFIG_DIR/_completions" $fpath)
for _boostish_comp_dir in "$BOOSTISH_CONFIG_DIR"/plugins/*/completions(N/); do
  fpath=("$_boostish_comp_dir" $fpath)
done
typeset -gU fpath FPATH

# Force custom completions to win if a system function was already loaded.
unfunction _ansible 2>/dev/null

: ${BOOSTISH_CACHE_DIR:="${XDG_CACHE_HOME:-$HOME/.cache}/boostish"}
if [[ ! -d "$BOOSTISH_CACHE_DIR" || ! -w "$BOOSTISH_CACHE_DIR" ]]; then
  mkdir -p "$BOOSTISH_CACHE_DIR" 2>/dev/null || true
fi
if [[ ! -d "$BOOSTISH_CACHE_DIR" || ! -w "$BOOSTISH_CACHE_DIR" ]]; then
  BOOSTISH_CACHE_DIR="${TMPDIR:-/tmp}/boostish-${UID}"
  mkdir -p "$BOOSTISH_CACHE_DIR"
fi
typeset -g BOOSTISH_CACHE_DIR
typeset -g ZSH_COMPDUMP="${ZSH_COMPDUMP:-$BOOSTISH_CACHE_DIR/.zcompdump-${HOST}-${ZSH_VERSION}}"
typeset -gi _boostish_compdump_rebuild=0

if [[ ! -s "$ZSH_COMPDUMP" ]]; then
  _boostish_compdump_rebuild=1
fi

if (( !_boostish_compdump_rebuild )) && [[ "$BOOSTISH_CONFIG_DIR/20-completions.zsh" -nt "$ZSH_COMPDUMP" ]]; then
  _boostish_compdump_rebuild=1
fi

if (( !_boostish_compdump_rebuild )); then
  for _boostish_comp_file in "$BOOSTISH_CONFIG_DIR"/_completions/*(N.); do
    if [[ "$_boostish_comp_file" -nt "$ZSH_COMPDUMP" ]]; then
      _boostish_compdump_rebuild=1
      break
    fi
  done
fi

if (( !_boostish_compdump_rebuild )); then
  for _boostish_comp_file in "$BOOSTISH_CONFIG_DIR"/plugins/*/completions/*(N.); do
    if [[ "$_boostish_comp_file" -nt "$ZSH_COMPDUMP" ]]; then
      _boostish_compdump_rebuild=1
      break
    fi
  done
fi

autoload -Uz compinit
if (( _boostish_compdump_rebuild )); then
  compinit -u -d "$ZSH_COMPDUMP"
else
  compinit -u -C -d "$ZSH_COMPDUMP"
fi

if [[ -s "$ZSH_COMPDUMP" && ( ! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc" ) ]]; then
  zcompile "$ZSH_COMPDUMP" &!
fi

unset _boostish_compdump_rebuild _boostish_comp_file _boostish_comp_dir

# Zinit completion (after compinit)
autoload -Uz _zinit
compdef _zinit zinit
