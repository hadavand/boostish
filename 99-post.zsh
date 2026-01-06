typeset -ga zle_highlight
zle_highlight+=('paste:none')

BOOSTISH_SSH_PREFIX='atrak-'
BOOSTISH_SSH_USER='vana'
boostish_ssh_aliases_from_hosts

if (( $+commands[bat] )); then
    export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
fi

if command -v docker >/dev/null 2>&1; then
    source <(docker completion zsh)
fi

if command -v k9s >/dev/null 2>&1; then
    source <(k9s completion zsh)
fi

if command -v volta >/dev/null 2>&1; then
    source <(volta completions zsh)
fi

if command -v codex >/dev/null 2>&1; then
    source <(codex completion zsh)
fi

if (( $+commands[helm] )); then
    # If the completion file does not exist, generate it and then source it
    # Otherwise, source it and regenerate in the background
    if [[ ! -f "$ZSH_CACHE_DIR/completions/_helm" ]]; then
        helm completion zsh | tee "$ZSH_CACHE_DIR/completions/_helm" >/dev/null
        source "$ZSH_CACHE_DIR/completions/_helm"
    else
        source "$ZSH_CACHE_DIR/completions/_helm"
        helm completion zsh | tee "$ZSH_CACHE_DIR/completions/_helm" >/dev/null &|
    fi
fi

if [[ -n "$TILIX_ID" || -n "$VTE_VERSION" ]]; then
    [[ -r /etc/profile.d/vte.sh ]] && source /etc/profile.d/vte.sh
fi

# Flatpak exported commands (user + system)
for p in "$HOME/.local/share/flatpak/exports/bin" "/var/lib/flatpak/exports/bin"; do
  [ -d "$p" ] && PATH="$PATH:$p"
done
export PATH
