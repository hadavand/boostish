#typeset -ga zle_highlight
#zle_highlight+=('paste:none')

if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
fi

_boostish_completion_cache_dir="${BOOSTISH_COMPLETION_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/boostish/completions}"

_boostish_source_completion() {
  local cmd="$1"
  local completion_subcommand="${2:-completion}"
  local completion_file="$_boostish_completion_cache_dir/_$cmd"
  local tmp_file="$completion_file.$$"

  (( $+commands[$cmd] )) || return

  if [[ ! -r "$completion_file" ]]; then
    mkdir -p "$_boostish_completion_cache_dir" || return
    if "$cmd" "$completion_subcommand" zsh >| "$tmp_file" 2>/dev/null; then
      mv -f "$tmp_file" "$completion_file"
    else
      rm -f "$tmp_file"
      return
    fi
  fi

  source "$completion_file"
}

for _boostish_completion_command in docker kubectl oc k9s codex helm crc podman minikube; do
  _boostish_source_completion "$_boostish_completion_command"
done

_boostish_source_completion volta completions

unset _boostish_completion_cache_dir _boostish_completion_command
unfunction _boostish_source_completion

if [[ -n "$TILIX_ID" || -n "$VTE_VERSION" ]]; then
  [[ -r /etc/profile.d/vte.sh ]] && source /etc/profile.d/vte.sh
fi
