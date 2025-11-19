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