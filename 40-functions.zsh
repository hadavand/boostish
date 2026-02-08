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

weather() { local city=${*:-Tehran}; curl -s "http://wttr.in/${city// /+}"; }

geoip() {
  command -v curl >/dev/null 2>&1 || { echo "geoip: curl not found"; return 127; }
  command -v jq >/dev/null 2>&1 || { echo "geoip: jq not found"; return 127; }
  curl -s -k https://api.ip.sb/geoip -H 'user-agent: boostish-proxy' | jq
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
