: ${BOOSTISH_ALIASES_EDITOR:=${EDITOR:-vim}}

# ----- global pipe aliases -----
alias -g B='| bat'
alias -g C='| copyq add - && copyq select 0'
alias -g G='| grep'
alias -g H='| head'
alias -g L="| less"
alias -g M='| more'
alias -g N='| nc termbin.com 9999'
alias -g T='| tail'
alias -g Z='| fzf'
alias -g V='xclip -o'
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

# ----- suffix aliases -----
alias -s zsh="$BOOSTISH_ALIASES_EDITOR"

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# mkdir helpers
alias md='mkdir -p'
alias rd='rmdir'

# disk usage
alias df='df -h'
alias du='du -h'

# zero file
alias zap=': >'
alias zap0='truncate -s0 --'

# colored grep
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

function ip() {
  if [ -t 1 ]; then
    command ip -color "$@"
  else
    command ip "$@"
  fi
}

function zombies() {
  ps -eal | awk '{ if ($2 == "Z") {print $4}}'
}

alias pg='ping 8.8.8.8 -c 5'
alias paths='print -l $path'
alias fpaths='print -l $fpath'
alias hist10='print -l ${(o)history%% *} | uniq -c | sort -nr | head -n 10'

alias python="python3"
alias apu="sudo apt update"
alias apug="sudo apt upgrade"
alias persianfonts='fc-list :lang=fa : family | sort | uniq | pr -3t'

if (( $+commands[lsd] )); then
    unalias ls l la lt 2>/dev/null
    alias ls='lsd'
    alias l='ls -l'
    alias la='ls -la'
    alias lt='ls --tree'
fi

if (( $+commands[ansible-playbook] )); then
    alias ap='ansible-playbook'
fi

if (( $+commands[bat] )); then
  alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
  alias bat='bat --paging=never'
fi

if (( $+commands[subl] )); then
  alias subl='subl --add'
fi

# Docker aliases
if (( $+commands[docker] )); then
  # build / images
  alias dbl='docker buildx build'
  
  alias dii='docker image inspect'
  alias dil='docker image ls'
  
  alias dcls='docker container ls'
  
  alias dcin='docker container inspect'
  alias dlo='docker container logs'

  # run / exec
  alias dr='docker container run'
  alias drit='docker container run -it'
  alias dxc='docker container exec'
  alias dxcit='docker container exec -it'

  # ps / pull / ports
  alias dps='docker ps'
  
  # stop *all* running containers ⚠
  alias dsta='docker stop $(docker ps -q)'

  # network
  alias dni='docker network inspect'
  alias dnls='docker network ls'

  # volumes
  alias dvi='docker volume inspect'
  alias dvls='docker volume ls'
  alias dvprune='docker volume prune'

  # misc
  alias dtop='docker top'
fi

# Docker Compose aliases
if (( ${+commands[docker-compose]} )) || command docker compose &>/dev/null; then
  if [[ -x "${commands[docker-compose]:A}" ]]; then
    dccmd='docker-compose'
  else
    dccmd='docker compose'
  fi

  alias dco="$dccmd"
  alias dcb="$dccmd build"
  alias dcw="$dccmd up -d --force-recreate --remove-orpahns --wait"
  alias dce="$dccmd exec"
  alias dcr="$dccmd run"
  alias dcdn="$dccmd down"
  alias dcl="$dccmd logs"
  alias dclf="$dccmd logs -f"
  alias dck="$dccmd kill"
  unset dccmd
fi

alias copyq='com.github.hluk.copyq'