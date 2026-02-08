# Boostish Shell Proxy — minimal

: ${BOOSTISH_PROXY_DIR:=${XDG_CONFIG_HOME:-$HOME/.config}/boostish/proxy}
: ${BOOSTISH_PROXY_HTTP:=http://127.0.0.1:2080}
: ${BOOSTISH_PROXY_SOCKS:=socks5h://127.0.0.1:2080}
: ${BOOSTISH_PROXY_NO_PROXY:="localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,*.local"}
: ${BOOSTISH_PROXY_GIT_TYPE:=socks}
: ${BOOSTISH_PROXY_APT_NO_PROXY:="calix.vanaboom.ir"}

_bxp_file() { print -r -- "$BOOSTISH_PROXY_DIR/$1"; }
_bxp_msg() { print -r -- "$@"; }
_bxp_err() { print -u2 -r -- "$@"; }

_bxp_write() { print -r -- "$2" >| "$(_bxp_file "$1")"; }

_bxp_ensure() {
  command mkdir -p -- "$BOOSTISH_PROXY_DIR" 2>/dev/null
  [[ -f "$(_bxp_file http)" ]]     || _bxp_write http "$BOOSTISH_PROXY_HTTP"
  [[ -f "$(_bxp_file socks)" ]]    || _bxp_write socks "$BOOSTISH_PROXY_SOCKS"
  [[ -f "$(_bxp_file no_proxy)" ]] || _bxp_write no_proxy "$BOOSTISH_PROXY_NO_PROXY"
  [[ -f "$(_bxp_file git_type)" ]] || _bxp_write git_type "$BOOSTISH_PROXY_GIT_TYPE"
  [[ -f "$(_bxp_file apt_no_proxy)" ]] || _bxp_write apt_no_proxy "$BOOSTISH_PROXY_APT_NO_PROXY"
}

_bxp_read() {
  _bxp_ensure
  __BXP_HTTP="$(<"$(_bxp_file http)")"
  __BXP_SOCKS="$(<"$(_bxp_file socks)")"
  __BXP_NO_PROXY="$(<"$(_bxp_file no_proxy)")"
  __BXP_GIT_TYPE="$(<"$(_bxp_file git_type)")"
  __BXP_APT_NO_PROXY="$(<"$(_bxp_file apt_no_proxy)")"

  if [[ -z "$__BXP_HTTP" ]]; then
    __BXP_HTTP="$BOOSTISH_PROXY_HTTP"
    _bxp_write http "$__BXP_HTTP"
  fi
  if [[ -z "$__BXP_SOCKS" ]]; then
    __BXP_SOCKS="$BOOSTISH_PROXY_SOCKS"
    _bxp_write socks "$__BXP_SOCKS"
  fi
  if [[ -z "$__BXP_NO_PROXY" ]]; then
    __BXP_NO_PROXY="$BOOSTISH_PROXY_NO_PROXY"
    _bxp_write no_proxy "$__BXP_NO_PROXY"
  fi
  if [[ -z "$__BXP_GIT_TYPE" ]]; then
    __BXP_GIT_TYPE="$BOOSTISH_PROXY_GIT_TYPE"
    _bxp_write git_type "$__BXP_GIT_TYPE"
  fi
  if [[ -z "$__BXP_APT_NO_PROXY" ]]; then
    __BXP_APT_NO_PROXY="$BOOSTISH_PROXY_APT_NO_PROXY"
    _bxp_write apt_no_proxy "$__BXP_APT_NO_PROXY"
  fi
}

_bxp_norm_http() {
  local v="$1"
  [[ -z "$v" ]] && { _bxp_err "proxy: missing http url"; return 1; }
  [[ "$v" == *://* ]] && print -r -- "$v" || print -r -- "http://$v"
}

_bxp_norm_socks() {
  local v="$1"
  [[ -z "$v" ]] && { _bxp_err "proxy: missing socks url"; return 1; }
  [[ "$v" == *://* ]] && print -r -- "$v" || print -r -- "socks5h://$v"
}

_bxp_env_on() {
  local http="$1" socks="$2" no_proxy="$3"
  export http_proxy="$http" https_proxy="$http" ftp_proxy="$http" rsync_proxy="$http"
  export HTTP_PROXY="$http" HTTPS_PROXY="$http" FTP_PROXY="$http" RSYNC_PROXY="$http"
  export all_proxy="$socks" ALL_PROXY="$socks"
  export no_proxy="$no_proxy" NO_PROXY="$no_proxy"
}

_bxp_env_off() {
  unset http_proxy https_proxy ftp_proxy rsync_proxy all_proxy
  unset HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY
  unset no_proxy NO_PROXY
}

_bxp_apply_git() {
  command -v git >/dev/null 2>&1 || return 0
  _bxp_read
  local url="$__BXP_HTTP"
  [[ "$__BXP_GIT_TYPE" == "socks" ]] && url="$__BXP_SOCKS"
  git config --global http.proxy "$url"
  git config --global https.proxy "$url"
}

_bxp_clear_git() {
  command -v git >/dev/null 2>&1 || return 0
  git config --global --unset http.proxy 2>/dev/null || true
  git config --global --unset https.proxy 2>/dev/null || true
}

_bxp_apply_npm() {
  _bxp_read
  if command -v npm >/dev/null 2>&1; then
    npm config set proxy "$__BXP_HTTP" >/dev/null 2>&1
    npm config set https-proxy "$__BXP_HTTP" >/dev/null 2>&1
  fi
  if command -v yarn >/dev/null 2>&1; then
    yarn config set proxy "$__BXP_HTTP" >/dev/null 2>&1
    yarn config set https-proxy "$__BXP_HTTP" >/dev/null 2>&1
  fi
  if command -v pnpm >/dev/null 2>&1; then
    pnpm config set proxy "$__BXP_HTTP" >/dev/null 2>&1
    pnpm config set https-proxy "$__BXP_HTTP" >/dev/null 2>&1
  fi
}

_bxp_clear_npm() {
  if command -v npm >/dev/null 2>&1; then
    npm config delete proxy >/dev/null 2>&1
    npm config delete https-proxy >/dev/null 2>&1
  fi
  if command -v yarn >/dev/null 2>&1; then
    yarn config delete proxy >/dev/null 2>&1
    yarn config delete https-proxy >/dev/null 2>&1
  fi
  if command -v pnpm >/dev/null 2>&1; then
    pnpm config delete proxy >/dev/null 2>&1
    pnpm config delete https-proxy >/dev/null 2>&1
  fi
}

_bxp_apply_apt() {
  _bxp_read
  if [[ "$__BXP_HTTP" == socks5* ]]; then
    _bxp_err "apt: SOCKS not supported; use HTTP proxy"
    return 1
  fi
  local f="/etc/apt/apt.conf.d/90proxy"
  {
    print -r -- "Acquire::http::Proxy \"$__BXP_HTTP\";"
    print -r -- "Acquire::https::Proxy \"$__BXP_HTTP\";"
  } | sudo tee "$f" >/dev/null

  local nf="/etc/apt/apt.conf.d/91noproxy"
  if [[ -n "$__BXP_APT_NO_PROXY" ]]; then
    local -a hosts
    hosts=(${(s:,:)__BXP_APT_NO_PROXY})
    {
      local h
      for h in $hosts; do
        [[ -z "$h" ]] && continue
        print -r -- "Acquire::http::Proxy::${h} \"DIRECT\";"
        print -r -- "Acquire::https::Proxy::${h} \"DIRECT\";"
      done
    } | sudo tee "$nf" >/dev/null
  else
    sudo rm -f -- "$nf" 2>/dev/null || true
  fi
}

_bxp_clear_apt() {
  local f="/etc/apt/apt.conf.d/90proxy"
  sudo rm -f -- "$f" 2>/dev/null || true
  local nf="/etc/apt/apt.conf.d/91noproxy"
  sudo rm -f -- "$nf" 2>/dev/null || true
}

_bxp_apply_all() {
  _bxp_apply_git
  _bxp_apply_npm
  _bxp_apply_apt
}

_bxp_clear_all() {
  _bxp_clear_git
  _bxp_clear_npm
  _bxp_clear_apt
}

_bxp_is_on() {
  [[ -n "${http_proxy:-${HTTP_PROXY:-}}" || -n "${all_proxy:-${ALL_PROXY:-}}" ]]
}

_bxp_status() {
  local http="${http_proxy:-${HTTP_PROXY:-}}"
  local socks="${all_proxy:-${ALL_PROXY:-}}"
  if [[ -n "$http" || -n "$socks" ]]; then
    _bxp_msg "proxy: ON"
  else
    _bxp_msg "proxy: OFF"
  fi
}

_bxp_env() {
  local keys=(http_proxy https_proxy ftp_proxy rsync_proxy all_proxy no_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY NO_PROXY)
  local k v
  for k in $keys; do
    v="${(P)k}"
    [[ -n "$v" ]] && print -r -- "${k}=${v}" || print -r -- "${k}=<unset>"
  done
}

_bxp_show() {
  _bxp_read
  _bxp_msg "http=${__BXP_HTTP}"
  _bxp_msg "socks=${__BXP_SOCKS}"
  _bxp_msg "no_proxy=${__BXP_NO_PROXY}"
  _bxp_msg "git_type=${__BXP_GIT_TYPE}"
  _bxp_msg "apt_no_proxy=${__BXP_APT_NO_PROXY}"
}

_bxp_set() {
  local key="$1" val="$2"
  case "$key" in
    http)
      val="$(_bxp_norm_http "$val")" || return 1
      _bxp_write http "$val"
      ;;
    socks|socks5|socks5h)
      val="$(_bxp_norm_socks "$val")" || return 1
      _bxp_write socks "$val"
      ;;
    no_proxy|noproxy)
      [[ -z "$val" ]] && { _bxp_err "proxy: missing no_proxy list"; return 1; }
      _bxp_write no_proxy "$val"
      ;;
    git)
      case "$val" in
        http|socks) _bxp_write git_type "$val" ;;
        *) _bxp_err "proxy: git type must be 'http' or 'socks'"; return 1 ;;
      esac
      ;;
    apt_no_proxy)
      [[ -z "$val" ]] && { _bxp_err "proxy: missing apt no_proxy list"; return 1; }
      _bxp_write apt_no_proxy "$val"
      ;;
    port|mixed)
      [[ -z "$val" ]] && { _bxp_err "proxy: missing port or host:port"; return 1; }
      local hostport="$val"
      [[ "$hostport" == *://* ]] && hostport="${hostport#*://}"
      [[ "$hostport" == *:* ]] || hostport="127.0.0.1:$hostport"
      _bxp_write http "http://$hostport"
      _bxp_write socks "socks5h://$hostport"
      ;;
    *)
      _bxp_err "proxy: unknown key '$key'"
      return 2
      ;;
  esac
}

_bxp_myip() {
  if command -v geoip >/dev/null 2>&1; then
    geoip
    return
  fi
  command -v curl >/dev/null 2>&1 || { _bxp_err "myip: geoip not found (curl missing too)"; return 127; }
  curl -s -k https://4.ident.me -H 'user-agent: boostish-proxy'
}

proxy() {
  local cmd="${1:-on}"
  case "$cmd" in
    on|enable|start)
      _bxp_read
      _bxp_env_on "$__BXP_HTTP" "$__BXP_SOCKS" "$__BXP_NO_PROXY"
      _bxp_apply_all
      _bxp_myip
      ;;
    off|disable|stop|unset|clear)
      _bxp_env_off
      _bxp_clear_all
      ;;
    status|st)
      _bxp_status
      ;;
    env)
      _bxp_env
      ;;
    show|config)
      _bxp_show
      ;;
    set)
      [[ -z "$2" ]] && { _bxp_err "proxy: set requires a key"; return 2; }
      _bxp_set "$2" "$3" || return $?
      if _bxp_is_on; then
        _bxp_read
        _bxp_env_on "$__BXP_HTTP" "$__BXP_SOCKS" "$__BXP_NO_PROXY"
        _bxp_apply_all
      fi
      ;;
    apply)
      case "$2" in
        git) _bxp_apply_git ;;
        npm) _bxp_apply_npm ;;
        apt) _bxp_apply_apt ;;
        all|"") _bxp_apply_all ;;
        *) _bxp_err "proxy: unknown target '$2'"; return 2 ;;
      esac
      ;;
    clear)
      case "$2" in
        git) _bxp_clear_git ;;
        npm) _bxp_clear_npm ;;
        apt) _bxp_clear_apt ;;
        all|"") _bxp_clear_all ;;
        *) _bxp_err "proxy: unknown target '$2'"; return 2 ;;
      esac
      ;;
    *)
      _bxp_err "proxy: usage: proxy on|off|status|env|show|set|apply|clear"
      return 2
      ;;
  esac
}
