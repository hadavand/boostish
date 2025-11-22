# zsh-syntax-highlighting: color palette (hex)
typeset -g ZSH_HL_WHITE='#ffffff'
typeset -g ZSH_HL_RED='#e06c75'
typeset -g ZSH_HL_ORANGE='#ff8700'
typeset -g ZSH_HL_YELLOW='#e5c07b'
typeset -g ZSH_HL_GREEN='#98c379'
typeset -g ZSH_HL_BLUE='#61afef'
typeset -g ZSH_HL_CYAN='#56b6c2'
typeset -g ZSH_HL_MAGENTA='#d3869b'
typeset -g ZSH_HL_COMMENT='#6c6c6c'
typeset -g ZSH_HL_PATH='#00afff'
typeset -g ZSH_HL_DIM='#808080'
typeset -g ZSH_HL_DEFAULT='#ffaf5f'
typeset -g ZSH_HL_OPT_MAGENTA='#ff5fff'

typeset -gA ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_MAXLENGTH=512
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor line)

ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=${ZSH_HL_RED}"
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#8700ff'
ZSH_HIGHLIGHT_STYLES[alias]="fg=${ZSH_HL_CYAN}"
ZSH_HIGHLIGHT_STYLES[suffix-alias]="fg=${ZSH_HL_GREEN},underline"
ZSH_HIGHLIGHT_STYLES[global-alias]="fg=${ZSH_HL_BLUE},bg=${ZSH_HL_WHITE},standout"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[function]="fg=${ZSH_HL_BLUE}"
ZSH_HIGHLIGHT_STYLES[command]="fg=${ZSH_HL_GREEN}"
ZSH_HIGHLIGHT_STYLES[precommand]="fg=${ZSH_HL_GREEN},underline"
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#5f875f,bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#0000af'
ZSH_HIGHLIGHT_STYLES[autodirectory]="fg=${ZSH_HL_PATH},underline"
ZSH_HIGHLIGHT_STYLES[path]="fg=${ZSH_HL_PATH},underline"
ZSH_HIGHLIGHT_STYLES[path_pathseparator]="fg=${ZSH_HL_PATH}"
ZSH_HIGHLIGHT_STYLES[path_prefix]='none'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]="fg=${ZSH_HL_DIM}"
ZSH_HIGHLIGHT_STYLES[globbing]="fg=${ZSH_HL_BLUE},bold"
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#5fd7af,bold'
ZSH_HIGHLIGHT_STYLES[command-substitution]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[process-substitution]='none'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=${ZSH_HL_ORANGE}"
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=${ZSH_HL_OPT_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='none'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]="fg=${ZSH_HL_RED},underline"
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]="fg=${ZSH_HL_BLUE},bold"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=${ZSH_HL_YELLOW}"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]="fg=${ZSH_HL_RED},underline"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=${ZSH_HL_YELLOW}"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]="fg=${ZSH_HL_RED},underline"
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=${ZSH_HL_YELLOW}"
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]="fg=${ZSH_HL_RED},underline"
ZSH_HIGHLIGHT_STYLES[rc-quote]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[assign]='none'
ZSH_HIGHLIGHT_STYLES[redirection]="fg=${ZSH_HL_BLUE},bold"
ZSH_HIGHLIGHT_STYLES[comment]="fg=${ZSH_HL_COMMENT},bold"
ZSH_HIGHLIGHT_STYLES[comment]="fg=${ZSH_HL_COMMENT},bold"
ZSH_HIGHLIGHT_STYLES[named-fd]='none'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='none'
ZSH_HIGHLIGHT_STYLES[arg0]="fg=${ZSH_HL_GREEN}"
ZSH_HIGHLIGHT_STYLES[default]="fg=${ZSH_HL_DEFAULT}"

ZSH_HIGHLIGHT_STYLES[line]='bold'

ZSH_HIGHLIGHT_STYLES[bracket-error]="fg=${ZSH_HL_RED},bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-1]="fg=${ZSH_HL_BLUE}"
ZSH_HIGHLIGHT_STYLES[bracket-level-2]="fg=${ZSH_HL_GREEN}"
ZSH_HIGHLIGHT_STYLES[bracket-level-3]="fg=${ZSH_HL_MAGENTA}"
ZSH_HIGHLIGHT_STYLES[bracket-level-4]="fg=${ZSH_HL_CYAN}"
ZSH_HIGHLIGHT_STYLES[bracket-level-5]="fg=${ZSH_HL_YELLOW}"
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]="fg=${ZSH_HL_YELLOW},bold"

ZSH_HIGHLIGHT_STYLES[cursor]='standout'

typeset -A ZSH_HIGHLIGHT_PATTERNS

ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=red,bg=white,bold,standout')
ZSH_HIGHLIGHT_PATTERNS+=('sudo rm -rf *' 'fg=red,bold,standout')

# --- auto suggestion
ZSH_AUTOSUGGEST_STRATEGY=("history completion")
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8,underline"

# --- example
# ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"
# ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c50,)"
# ZSH_AUTOSUGGEST_COMPLETION_IGNORE="git *"



