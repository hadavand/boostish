if [[ -n "$TILIX_ID" || -n "$VTE_VERSION" ]]; then
  [[ -r /etc/profile.d/vte.sh ]] && source /etc/profile.d/vte.sh
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Behavior
setopt MAGIC_EQUAL_SUBST
setopt NO_NOMATCH
setopt NUMERIC_GLOB_SORT
setopt EXTENDED_GLOB
setopt GLOB_DOTS

# Safety
setopt RM_STAR_WAIT
setopt NO_BEEP

# Directory
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt AUTO_CD

# History
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt APPEND_HISTORY
setopt NO_HUP

# Redirection & Pipelines
setopt MULTIOS
setopt PIPE_FAIL

setopt PATH_DIRS

WORDCHARS=${WORDCHARS/\/}

export EDITOR="vim"
# PATH tweaks
export PATH="$HOME/bin:$PATH"

export FZF_DEFAULT_OPTS="
    --style=default
    --height=80%

    --layout=reverse
    --border=rounded
    --border-label=' Majid '

    --margin=0,0
    --padding=0,1

    --prompt=' '
    --pointer=' '
    --marker=' '
    --separator=''
    --scrollbar='▌'

    --color=fg:#91aab0,fg+:#2ecbcb,bg:-1,bg+:#1b292f
    --color='hl:#4ba3f6,hl+:#82c0ff'
    --color='info:#7a8288,spinner:#b57bea,header:#7a8288'
    --color='prompt:#b57bea,pointer:#4fe8d7,marker:#28c7b7'
    --color='border:#2a2f3a,label:#d0d0d0,query:#ffffff'
    --color='preview-border:#3b4261,preview-label:#a5b8e6'
    --color='list-border:#40574a,list-label:#9fd9a8'
    --color='input-border:#4a3f45,input-label:#f0c4c4'
    --color='header-border:#3a4e6d,header-label:#a9c6f2'
"

export FZF_CTRL_T_OPTS="
    --style=full

    --prompt=' '

    --border-label=' Files (Ctrl+T) '

    --input-label=' Input '
    --header-label=' File Type '

    --preview='fzf-preview.sh {}'
    --preview-window='border-rounded'

    --bind='result:transform-list-label:
        if [[ -z \$FZF_QUERY ]]; then
            echo \" \$FZF_MATCH_COUNT items \"
        else
            echo \" \$FZF_MATCH_COUNT matches for [\$FZF_QUERY] \"
        fi
    '

    --bind='focus:transform-preview-label:
        [[ -n {} ]] && printf \" Previewing [%s] \" {}
    '

    --bind='focus:+transform-header:
      file --brief {} 2>/dev/null || echo \"No file selected\"
    '
    --walker-skip='.git,node_modules,target,.npm'
"

export FZF_CTRL_R_OPTS="
    --style=minimal
    --prompt=' '
    --border-label=' History (CTRL+R) '
    --input-label=' Record '
"

export FZF_ALT_C_OPTS="
    --style=full
    --border-label=' Folders (ALT+C) '
    --input-label=' Directory '

    --prompt=' '
    --preview='tree -C {} 2>/dev/null | head -n 200'
"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh