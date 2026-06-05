## Diagnostics

bench_zsh_startup() {
  local runs="${1:-20}" i

  [[ "$runs" == <-> && "$runs" -gt 0 ]] || {
    echo "Usage: bench_zsh_startup [runs]" >&2
    return 2
  }

  for (( i = 1; i <= runs; i++ )); do
    /usr/bin/time -f '%e' zsh -i -c exit >/dev/null
  done 2>&1 | awk '/^[0-9.]+$/ {
    n++
    sum += $1
    if (n == 1 || $1 < min) min = $1
    if ($1 > max) max = $1
  } END {
    if (n > 0) {
      printf "n=%d avg=%.3fs min=%.3fs max=%.3fs\n", n, sum / n, min, max
    }
  }'
}

## Clipboard and notifications

: ${BOOSTISH_COPYQ_FLATPAK_ID:=com.github.hluk.copyq}

_boostish_copyq_available() {
  (( $+commands[copyq] || $+commands[flatpak] ))
}

_boostish_copyq() {
  if (( $+commands[copyq] )); then
    command copyq "$@"
  elif (( $+commands[flatpak] )); then
    command flatpak run "$BOOSTISH_COPYQ_FLATPAK_ID" "$@"
  else
    return 127
  fi
}

_boostish_clipboard_copy() {
  if ! _boostish_copyq_available; then
    print -u2 "copyq not found"
    return 1
  fi

  local text
  text=$(<&0)
  printf "%s" "$text" | _boostish_copyq add - && _boostish_copyq select 0
}

bgnotify_threshold=3

_display_time() {
  local t=${1:-0} d h m s
  local -a parts

  (( t = t < 0 ? 0 : t ))
  (( d = t / 86400, h = t / 3600 % 24, m = t / 60 % 60, s = t % 60 ))

  (( d )) && parts+=("${d}d")
  (( h )) && parts+=("${h}h")
  (( m )) && parts+=("${m}m")
  parts+=("${s}s")

  printf '%s' "${(j: :)parts}"
}

bgnotify_formatted() {
  local exit_status=$1 cmd_full=$2 elapsed=$3
  local cmd duration icon preview

  cmd_full=${cmd_full%%$'\n'*}
  cmd=${cmd_full%% *}

  preview=$cmd_full
  (( ${#preview} > 80 )) && preview="${preview[1,77]}..."

  duration=$(_display_time "$elapsed")

  if (( exit_status == 0 )); then
    icon="✅"
  else
    icon="❌"
  fi

  bgnotify "$icon $cmd" "$preview · ⏱ $duration"
}

## Network helpers

weather() {
  (( $+commands[curl] )) || { print -u2 "weather: curl not found"; return 127; }

  local city=${*:-Tehran}
  command curl -s "http://wttr.in/${city// /+}"
}

: ${BOOSTISH_MYIP_GEO_URL:=https://api.ip.sb/geoip}
: ${BOOSTISH_MYIP_IP_URL:=https://icanhazip.com}
: ${BOOSTISH_MYIP_PROXY_URL:=127.0.0.1:10808}
: ${BOOSTISH_MYIP_TIMEOUT:=8}
: ${BOOSTISH_MYIP_USER_AGENT:=boostish-myip}

_boostish_myip_proxy_http() {
  local dir="${BOOSTISH_PROXY_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/boostish/proxy}"
  local f="$dir/http"
  local proxy_url

  if [[ -r "$f" ]]; then
    proxy_url="$(<"$f")"
    [[ -n "$proxy_url" ]] && { print -r -- "$proxy_url"; return 0; }
  fi

  print -r -- "${BOOSTISH_PROXY_HTTP:-${BOOSTISH_MYIP_PROXY_URL:-127.0.0.1:10808}}"
}

_boostish_myip_usage() {
  cat <<'EOF'
Usage: myip [--json|--ip] [--proxy|--direct|--domestic] [options]

Output:
  --json, --geo, --geoip   Show pretty geoip JSON (default)
  --ip, --raw              Show only the public IP

Route:
  --env                    Use current curl/proxy environment (default)
  --proxy                  Use Boostish stored HTTP proxy
  --proxy-url [URL]        Use an explicit HTTP proxy URL (default: 127.0.0.1:10808)
  --direct, --domestic     Ignore proxy env for this request

Options:
  --timeout SECONDS        Curl timeout (default: 8)
  --url URL                Override lookup URL for the selected output
  -h, --help               Show this help
EOF
}

myip() {
  local mode=geo route=env timeout="${BOOSTISH_MYIP_TIMEOUT:-8}"
  local url="" proxy_url="" curl_bin body
  local -a curl_args cmd

  while (( $# )); do
    case "$1" in
      --json|--geo|--geoip)
        mode=geo
        ;;
      --ip|--raw)
        mode=ip
        ;;
      --env|--current)
        route=env
        ;;
      --proxy)
        route=proxy
        ;;
      --proxy-url|--http-proxy)
        route=proxy
        if (( $# > 1 )) && [[ "$2" != -* ]]; then
          proxy_url="$2"
          shift
        else
          proxy_url="${BOOSTISH_MYIP_PROXY_URL:-127.0.0.1:10808}"
        fi
        ;;
      --direct|--domestic|--no-proxy)
        route=direct
        ;;
      --timeout)
        shift
        [[ "$1" == <-> ]] || { echo "myip: --timeout requires seconds" >&2; return 2; }
        timeout="$1"
        ;;
      --url)
        shift
        [[ -n "$1" ]] || { echo "myip: --url requires a value" >&2; return 2; }
        url="$1"
        ;;
      '-h'|'--help')
        _boostish_myip_usage
        return 0
        ;;
      *)
        echo "myip: unknown option '$1'" >&2
        _boostish_myip_usage >&2
        return 2
        ;;
    esac
    shift
  done

  curl_bin="$(command -v curl)" || { echo "myip: curl not found" >&2; return 127; }
  if [[ "$mode" == geo ]] && ! command -v jq >/dev/null 2>&1; then
    echo "myip: jq not found" >&2
    return 127
  fi

  [[ -n "$url" ]] || {
    if [[ "$mode" == ip ]]; then
      url="${BOOSTISH_MYIP_IP_URL:-https://icanhazip.com}"
    else
      url="${BOOSTISH_MYIP_GEO_URL:-https://api.ip.sb/geoip}"
    fi
  }

  curl_args=(-fsSL -k --max-time "$timeout" --connect-timeout "$timeout" -H "user-agent: ${BOOSTISH_MYIP_USER_AGENT:-boostish-myip}")

  case "$route" in
    proxy)
      [[ -n "$proxy_url" ]] || proxy_url="$(_boostish_myip_proxy_http)"
      curl_args+=(--proxy "$proxy_url" --noproxy "")
      cmd=("$curl_bin")
      ;;
    direct)
      curl_args+=(--noproxy "*")
      cmd=(env -u http_proxy -u https_proxy -u ftp_proxy -u rsync_proxy -u all_proxy -u no_proxy -u HTTP_PROXY -u HTTPS_PROXY -u FTP_PROXY -u RSYNC_PROXY -u ALL_PROXY -u NO_PROXY "$curl_bin")
      ;;
    env)
      cmd=("$curl_bin")
      ;;
    *)
      echo "myip: invalid route '$route'" >&2
      return 2
      ;;
  esac

  body="$("${cmd[@]}" "${curl_args[@]}" "$url")" || return $?
  if [[ "$mode" == geo ]]; then
    print -r -- "$body" | jq .
  else
    print -r -- "$body"
  fi
}

geoip() {
  myip --json "$@"
}

## Tokens

passgen() {
  local length="${1:-16}" strength="${2:-3}" charset

  # length must be positive integer
  [[ $length == <-> ]] || { echo "Usage: passgen [length] [strength 1-4]"; return 1; }

  case "$strength" in
    1) charset='[:lower:]' ;;
    2) charset='[:lower:][:upper:]' ;;
    3) charset='[:lower:][:upper:][:digit:]' ;;
    4) charset='[:alnum:]!@#$%^&*()_+-=' ;;
    *) echo "Usage: passgen [length] [strength 1-4]"; return 1 ;;
  esac

  LC_ALL=C tr -dc "$charset" </dev/urandom | head -c "$length"
  echo
}

b64_token() {
  [[ $# -ne 1 ]] && { echo "Usage: b64_token user:pass" >&2; return 1; }
  printf '%s' "$1" | base64
}

## Desktop helpers

open() {
  (( $+commands[xdg-open] )) || { print -u2 "open: xdg-open not found"; return 127; }
  command xdg-open "$@" >/dev/null 2>&1 &!
}

browse() {
  (( $+commands[google-chrome] )) || { print -u2 "browse: google-chrome not found"; return 127; }
  command google-chrome --new-tab "$@"
}

## Boostish maintenance

boostish_clear_completion_cache() {
  local cache_dir="${BOOSTISH_COMPLETION_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/boostish/completions}"
  local cmd file
  local -a files=()

  if (( $# == 0 )); then
    files=("$cache_dir"/_*(N))
  else
    for cmd in "$@"; do
      if [[ -z "$cmd" || "$cmd" == */* ]]; then
        echo "boostish_clear_completion_cache: invalid command '$cmd'" >&2
        return 2
      fi

      file="$cache_dir/_$cmd"
      [[ -e "$file" ]] && files+=("$file")
    done
  fi

  if (( ${#files} == 0 )); then
    echo "No completion cache files found."
    return 0
  fi

  command rm -f -- "${files[@]}"
  echo "Removed ${#files} completion cache file(s)."
}
