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

history_top10() {
  history | awk '{print $2}' | sort | uniq -c | sort -nr | head -10
}

weather() { local city=${*:-Tehran}; curl -s "http://wttr.in/${city// /+}"; }

function geoip() {
  if [[ -z $1 ]]; then
    curl http://ident.me 
    return
  fi
  curl https://api.ip.sb/geoip/$1 | jq
}

geoip() {
  local ip jq_ok=0
  command -v jq >/dev/null 2>&1 && jq_ok=1

  if [[ -t 0 ]]; then
    ip=${1:-}

    if [[ -z "$ip" ]]; then
      curl -s https://ident.me; echo
      return
    fi

    if (( jq_ok )); then
      curl -s "https://api.ip.sb/geoip/${ip}" | jq
    else
      curl -s "https://api.ip.sb/geoip/${ip}"
    fi
    return
  fi

  while IFS=$' \t' read -r ip _; do
    [[ -z "$ip" ]] && continue
    if (( jq_ok )); then
      curl -s "https://api.ip.sb/geoip/${ip}" | jq
    else
      curl -s "https://api.ip.sb/geoip/${ip}"
    fi
  done
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

color_code_256() {
  for code in {0..255}; do
    echo "\e[38;5;${code}m"'\\e[38;5;'"$code"m"\e[0m"
  done
}