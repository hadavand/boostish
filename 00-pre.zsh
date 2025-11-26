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
setopt EXTENDED_HISTORY          # ذخیره زمان و مدت اجرای هر دستور
setopt HIST_EXPIRE_DUPS_FIRST    # موقع خالی‌کردن history، اول دابل‌ها پاک بشن
# ONE of the following two lines
# setopt HIST_IGNORE_ALL_DUPS     # همیشه فقط آخرین نسخه‌ی هر دستور بمونه
setopt HIST_IGNORE_DUPS          # اگر دو دستور پشت‌سرهم یکسان بود، فقط یکی ذخیره شه
setopt HIST_IGNORE_SPACE         # دستوراتی که با space شروع می‌شن، تو history نرن
setopt HIST_SAVE_NO_DUPS         # تو فایل history دابل نداشته باشیم
setopt HIST_REDUCE_BLANKS        # فاصله‌های اضافه قبل از ذخیره شدن جمع بشن
setopt SHARE_HISTORY             # اشتراک history بین همه شل‌های باز
setopt INC_APPEND_HISTORY_TIME   # ثبت هر دستور بلافاصله در فایل، همراه زمان
setopt APPEND_HISTORY            # append به فایل history، نه overwrite
setopt NO_HUP                    # شل روی exit به jobها HUP نفرسته

# Redirection & Pipelines
setopt MULTIOS
setopt PIPE_FAIL

setopt PATH_DIRS

WORDCHARS=${WORDCHARS/\/}

export EDITOR="vim"
export BAT_THEME="dark"
export BAT_THEME_DARK="OneHalfDark"

typeset -U path PATH

[ -f ~/.boostish/fzf.zsh ] && source ~/.boostish/fzf.zsh

if [[ -d "$HOME/.volta/bin" ]]; then
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
fi

# goenv core
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

export GOPATH="$HOME/go"
export GOBIN="$HOME/.local/bin"
export PATH="$GOBIN:$PATH"

# golang
# export GOROOT=/usr/local/go
# export GOPATH=$HOME/go
# export PATH=$GOPATH/bin:$GOROOT/bin:$PATH