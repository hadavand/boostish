# human readable duration like "1h 3m 5s"
displaytime() {
  local t=$1 d h m s
  local -a parts=()

  (( t < 0 )) && t=0

  d=$(( t / 86400 ))
  h=$(( t / 3600 % 24 ))
  m=$(( t / 60 % 60 ))
  s=$(( t % 60 ))

  (( d > 0 )) && parts+="${d}d"
  (( h > 0 )) && parts+="${h}h"
  (( m > 0 )) && parts+="${m}m"
  parts+="${s}s"

  printf '%s' "${(j: :)parts}"
}

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

bgnotify_formatted() {
  local exit_status=$1 cmd_full=$2 elapsed=$3
  local cmd duration icon title preview

  cmd_full=${cmd_full%%$'\n'*}
  cmd=${cmd_full%% *}

  preview=$cmd_full
  (( ${#preview} > 80 )) && preview="${preview[1,77]}..."

  duration=$(displaytime "$elapsed")

  if (( exit_status == 0 )); then
    icon="✅"; title="Done"
  else
    icon="❌"; title="Failed"
  fi

  bgnotify "$icon $title [$cmd]" "⏱ $duration • $preview"
}

weather() { local city=${*:-Tehran}; curl -s "http://wttr.in/${city// /+}"; }

: ${BOOSTISH_MYIP_GEO_URL:=https://api.ip.sb/geoip}
: ${BOOSTISH_MYIP_IP_URL:=https://4.ident.me}
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
      url="${BOOSTISH_MYIP_IP_URL:-https://4.ident.me}"
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

open() {
  xdg-open "$@" >/dev/null 2>&1 &!
}

browse() { google-chrome --new-tab "$@"; }

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

# Default config (can be overridden before calling the function)
typeset -g BOOSTISH_SSH_USER="${BOOSTISH_SSH_USER:-boostish}"
typeset -g BOOSTISH_SSH_PREFIX="${BOOSTISH_SSH_PREFIX:-my-}"

boostish_ssh_aliases_from_hosts() {
  local hosts_file="${1:-/etc/hosts}"
  local user="${BOOSTISH_SSH_USER}"
  local prefix="${BOOSTISH_SSH_PREFIX}"
  local ip name rest

  while read -r ip name rest; do
    [[ -z $ip || $ip == \#* || -z $name ]] && continue
    [[ -n $prefix && $name != ${prefix}* ]] && continue
    alias "$name"="ssh ${user}@${ip}"
  done < <(grep -Ev '^\s*#|^\s*$' "$hosts_file")
}

color_palette_256() {
  local -a colors
  for i in {000..255}; do
    colors+=("%F{$i}$i%f")
  done
  print -cP $colors
}

corlor_print_code() {
  local color="%F{$1}"
  echo -E ${(qqqq)${(%)color}}
}

color_code_256() {
  for code in {0..255}; do
    echo "\e[38;5;${code}m"'\\e[38;5;'"$code"m"\e[0m"
  done
}

color_code_text() {
  for i in 00{2..8} {0{3,4,9},10}{0..7}; do
    echo -e "$i \e[0;${i}mSubdermatoglyphic text\e[00m  \e[1;${i}mSubdermatoglyphic text\e[00m"
  done
}

color_num_text() {
  for i in 00{2..8} {0{3,4,9},10}{0..7}; do
    for j in 0 1; do
      echo -e "$j;$i \e[$j;${i}mSubdermatoglyphic text\e[00m"
    done
  done
}

color_ansi() {
  for code in {30..37}; do
    echo -en "\e[${code}m"'\\e['"$code"'m'"\e[0m"
    echo -en "  \e[$code;1m"'\\e['"$code"';1m'"\e[0m"
    echo -en "  \e[$code;3m"'\\e['"$code"';3m'"\e[0m"
    echo -en "  \e[$code;4m"'\\e['"$code"';4m'"\e[0m"
    echo -e "  \e[$((code + 60))m"'\\e['"$((code + 60))"'m'"\e[0m"
  done
}

color_truecolor() {
  for i in {0..255}; do
    print -Pn '%K{$i}  %k%F{$i}${(l:3::0:)i}%f ' '${${(M)$((i%6)):#3}:+\n}'
  done
}

color_hex_preview() {
  local hex=${1#\#}
  [[ -z "$hex" || ${#hex} -ne 6 ]] && { echo "Usage: hexpreview #rrggbb"; return 1; }

  local r=$((16#${hex[1,2]}))
  local g=$((16#${hex[3,4]}))
  local b=$((16#${hex[5,6]}))

  printf " fg  \e[38;2;%d;%d;%dm████ HEX #%s\e[0m\n" $r $g $b "$hex"
  printf " bg  \e[48;2;%d;%d;%dm    \e[0m HEX #%s\n"        $r $g $b "$hex"
}

hexpicker() {
  command -v fzf >/dev/null 2>&1 || { echo "fzf is required"; return 1; }

  local step=${1:-51} line hex
  line=$(
    for ((r=0; r<=255; r+=step)); do
      for ((g=0; g<=255; g+=step)); do
        for ((b=0; b<=255; b+=step)); do
          printf "\e[48;2;%d;%d;%dm    \e[0m  #%02X%02X%02X\n" $r $g $b $r $g $b
        done
      done
    done | fzf --ansi --no-sort --reverse --height=80% --prompt='Color > '
  ) || return 1

  hex=${line##*\#}
  hex=${hex%% *}
  printf '#%s\n' "$hex"
}

# Lenovo battery helpers
battery_conserve_path() {
  local p
  p=(/sys/bus/platform/drivers/ideapad_acpi/*/conservation_mode(N))
  [[ -z $p ]] && { echo "conservation_mode path not found" >&2; return 1; }
  echo "$p"
}

battery_conserve_on() {
  local p
  p=$(battery_conserve_path) || return 1
  echo 1 | sudo tee "$p"
}

battery_conserve_off() {
  local p
  p=$(battery_conserve_path) || return 1
  echo 0 | sudo tee "$p"
}

battery_conserve_status() {
  local p
  p=$(battery_conserve_path) || return 1
  echo -n "conservation_mode: "
  cat "$p"
}

battery_cycle_path() {
  local p
  p=(/sys/class/power_supply/BAT*/cycle_count(N))
  [[ -z $p ]] && { echo "cycle_count path not found" >&2; return 1; }
  echo "$p"
}

battery_cycle_count() {
  local p
  p=$(battery_cycle_path) || return 1
  echo -n "battery cycle count: "
  cat "$p"
}

power_profile_performance() {
  powerprofilesctl set performance
}

power_profile_balanced() {
  powerprofilesctl set balanced
}

power_profile_save() {
  powerprofilesctl set power-saver
}

b64_token() {
  [[ $# -ne 1 ]] && { echo "Usage: b64_token user:pass" >&2; return 1; }
  printf '%s' "$1" | base64
}

docker_app_aliases_on() {
  alias artisan='docker compose exec app php artisan'
  alias composer='docker compose exec app composer'
  alias npm='docker compose exec app npm'
}

docker_app_aliases_off() {
  unalias artisan 2>/dev/null
  unalias composer 2>/dev/null
  unalias npm 2>/dev/null
}

docker_app_aliases_toggle() {
  if alias artisan >/dev/null 2>&1; then
    docker_app_aliases_off
  else
    docker_app_aliases_on
  fi
}
