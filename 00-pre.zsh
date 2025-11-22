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

# # Safe paste: don't auto-execute pasted commands with newline
# autoload -Uz bracketed-paste-magic url-quote-magic
# zle -N bracketed-paste bracketed-paste-magic
# zle -N self-insert url-quote-magic

# if ! bindkey | grep -q 'bracketed-paste'; then
#   bindkey '^[[200~' bracketed-paste
# fi

[ -f ~/.boostish/fzf.zsh ] && source ~/.boostish/fzf.zsh