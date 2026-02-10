#typeset -ga zle_highlight
#zle_highlight+=('paste:none')

if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
fi

: ${BOOSTISH_CACHE_DIR:="${XDG_CACHE_HOME:-$HOME/.cache}/boostish"}
: ${BOOSTISH_COMPLETION_CACHE_TTL:=86400}
if [[ ! -d "$BOOSTISH_CACHE_DIR" || ! -w "$BOOSTISH_CACHE_DIR" ]]; then
  mkdir -p "$BOOSTISH_CACHE_DIR" 2>/dev/null || true
fi
if [[ ! -d "$BOOSTISH_CACHE_DIR" || ! -w "$BOOSTISH_CACHE_DIR" ]]; then
  BOOSTISH_CACHE_DIR="${TMPDIR:-/tmp}/boostish-${UID}"
  mkdir -p "$BOOSTISH_CACHE_DIR"
fi
typeset -g BOOSTISH_CACHE_DIR
[[ -d "$BOOSTISH_CACHE_DIR/completions" ]] || mkdir -p "$BOOSTISH_CACHE_DIR/completions"

boostish_source_cached_completion() {
  local completion_name="$1"
  shift

  local cache_file="$BOOSTISH_CACHE_DIR/completions/_${completion_name}"
  local tmp_file="${cache_file}.tmp"
  local now mtime age

  now=${EPOCHSECONDS:-$(date +%s)}
  mtime=$(command stat -c %Y "$cache_file" 2>/dev/null || command stat -f %m "$cache_file" 2>/dev/null || echo 0)
  [[ "$mtime" == <-> ]] || mtime=0
  age=$(( now - mtime ))

  if [[ ! -s "$cache_file" ]]; then
    "$@" >| "$cache_file" 2>/dev/null || return 0
    source "$cache_file"
    return 0
  fi

  source "$cache_file"

  if (( age >= BOOSTISH_COMPLETION_CACHE_TTL )); then
    {
      "$@" >| "$tmp_file" 2>/dev/null && mv -f "$tmp_file" "$cache_file"
    } &!
  fi
}

if (( $+commands[docker] )); then
  boostish_source_cached_completion docker docker completion zsh
fi

if (( $+commands[k9s] )); then
  boostish_source_cached_completion k9s k9s completion zsh
fi

if (( $+commands[volta] )); then
  boostish_source_cached_completion volta volta completions zsh
fi

if (( $+commands[codex] )); then
  boostish_source_cached_completion codex codex completion zsh
fi

if (( $+commands[helm] )); then
  boostish_source_cached_completion helm helm completion zsh
fi

if [[ -n "$TILIX_ID" || -n "$VTE_VERSION" ]]; then
  [[ -r /etc/profile.d/vte.sh ]] && source /etc/profile.d/vte.sh
fi
