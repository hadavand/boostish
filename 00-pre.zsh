if [[ $TTY == /dev/tty[1-6] ]]; then
  PROMPT='%n@%m:%~ %# '
  return 1
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
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
setopt interactivecomments

# Safety
setopt RM_STAR_WAIT
setopt NO_BEEP

# Directory
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt AUTO_CD

# History size & file
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# History behavior
setopt EXTENDED_HISTORY          # record timestamp and duration for each command
setopt HIST_EXPIRE_DUPS_FIRST    # drop duplicates first when trimming history
# ONE of the following two lines
# setopt HIST_IGNORE_ALL_DUPS     # keep only the most recent instance of each command
setopt HIST_IGNORE_DUPS          # ignore consecutive duplicate commands
setopt HIST_IGNORE_SPACE         # don't save commands that start with a space
setopt HIST_SAVE_NO_DUPS         # avoid saving duplicates to the history file
setopt HIST_REDUCE_BLANKS        # trim extra blanks before saving
setopt SHARE_HISTORY             # share history across all shells
setopt INC_APPEND_HISTORY_TIME   # write each command immediately with timestamp
setopt APPEND_HISTORY            # append to history file instead of overwrite
setopt NO_HUP                    # don't send HUP to jobs on shell exit

# Redirection & Pipelines
setopt MULTIOS                   # allow multiple redirections to the same target
setopt PIPE_FAIL                 # return failure if any pipeline command fails

setopt NO_CLOBBER                # prevent overwriting files with >
setopt COMPLETE_IN_WORD          # enable completion in the middle of a word
setopt ALWAYS_TO_END             # move cursor to end after completion
setopt HIST_FIND_NO_DUPS         # skip duplicates when searching history
setopt HIST_VERIFY               # show expanded history before executing

typeset -gU path PATH

WORDCHARS=${WORDCHARS/\/}

export EDITOR="vim"
export PAGER='less -R --mouse --wheel-lines=3'
export LESS='-R -F -i -M -S -w --mouse --wheel-lines=3'
export BAT_THEME="dark"
export BAT_THEME_DARK="OneHalfDark"

[ -f "${BOOSTISH_CONFIG_DIR:-$HOME/.boostish}/10-fzf.zsh" ] && \
  source "${BOOSTISH_CONFIG_DIR:-$HOME/.boostish}/10-fzf.zsh"

if [[ -d "$HOME/.volta/bin" ]]; then
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
fi

# goenv core
# export GOENV_ROOT="$HOME/.goenv"
# export PATH="$GOENV_ROOT/bin:$PATH"
# eval "$(goenv init -)"

# export GOPATH="$HOME/go"
# export GOBIN="$HOME/.local/bin"
# export PATH="$GOBIN:$PATH"

# golang
# export GOROOT=/usr/local/go
# export GOPATH=$HOME/go
# export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
