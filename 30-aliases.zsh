: ${BOOSTISH_ALIASES_EDITOR:=${EDITOR:-vim}}

# ----- global pipe aliases -----
alias -g B='| bat'
alias -g C='| _boostish_clipboard_copy'
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

# ----- shell basics -----
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

alias md='mkdir -p'
alias rd='rmdir'
alias df='df -h'
alias du='du -h'
alias zap=': >'
alias zap0='truncate -s0 --'

# ----- display helpers -----
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

alias paths='print -l $path'
alias fpaths='print -l $fpath'
alias history='fc -il 1'
alias hist10='print -l ${(o)history%% *} | uniq -c | sort -nr | head -n 10'

if (( $+commands[bat] )); then
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
  alias bat='bat --paging=never'
fi

if (( $+commands[lsd] )); then
  unalias ls l la lt 2>/dev/null
  alias ls='lsd'
  alias l='ls -l'
  alias la='ls -la'
  alias lt='ls --tree'
fi

# ----- system helpers -----
alias pg='ping 8.8.8.8 -c 5'

if (( $+commands[ip] )); then
  alias ip='ip -color=auto'
fi

if (( ! $+commands[python] && $+commands[python3] )); then
  alias python='python3'
fi

if (( $+commands[fc-list] && $+commands[pr] )); then
  alias persianfonts='fc-list :lang=fa : family | sort | uniq | pr -3t'
fi

# ----- editor helpers -----
if (( $+commands[subl] )); then
  alias subl='subl -a'
fi

# ----- command shortcuts -----
if (( $+commands[ansible-playbook] )); then
  alias ap='ansible-playbook'
fi

if (( $+commands[docker] )); then
  alias dbl='docker buildx build'
  alias dii='docker image inspect'
  alias dil='docker image ls'
  alias dcls='docker container ls'
  alias dcin='docker container inspect'
  alias dlo='docker container logs'
  alias dr='docker container run'
  alias drit='docker container run -it'
  alias dxc='docker container exec'
  alias dxcit='docker container exec -it'
  alias dps='docker ps'
  alias dni='docker network inspect'
  alias dnls='docker network ls'
  alias dvi='docker volume inspect'
  alias dvls='docker volume ls'
  alias dvprune='docker volume prune'
  alias dtop='docker top'

  alias dco="docker compose"
  alias dcb="docker compose build"
  alias dcw="docker compose up -d --force-recreate --remove-orphans --wait"
  alias dce="docker compose exec"
  alias dcr="docker compose run"
  alias dcdn="docker compose down"
  alias dcl="docker compose logs"
  alias dclf="docker compose logs -f"
  alias dck="docker compose kill"
fi

if (( $+commands[kubectl] )); then
  alias k='kubectl'
  alias kg='kubectl get'
  alias kd='kubectl describe'
  alias ka='kubectl apply'
  alias kdel='kubectl delete'
  alias kl='kubectl logs'
  alias klf='kubectl logs -f'
  alias kex='kubectl exec'
  alias kexit='kubectl exec -it'
  alias kctx='kubectl config current-context'
  alias kctxs='kubectl config get-contexts'
  alias kns='kubectl config set-context --current --namespace'
fi

if (( $+commands[oc] )); then
  alias og='oc get'
  alias od='oc describe'
  alias oa='oc apply'
  alias odel='oc delete'
  alias ol='oc logs'
  alias olf='oc logs -f'
  alias oex='oc exec'
  alias oexit='oc exec -it'
  alias ologin='oc login'
  alias op='oc project'
  alias ops='oc projects'
fi
