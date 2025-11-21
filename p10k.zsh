# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function prompt_my_cpu_temp() {
  [[ -f /sys/class/thermal/thermal_zone0/temp ]] || return

  integer cpu_temp=$(( $(</sys/class/thermal/thermal_zone0/temp) / 1000 ))

  if (( cpu_temp >= 80 )); then
    p10k segment -s HOT  -f red    -t "${cpu_temp}"$'\uE339' -i $'\uF737'
  elif (( cpu_temp >= 60 )); then
    p10k segment -s WARM -f yellow -t "${cpu_temp}"$'\uE339' -i $'\uE350'
  else
    p10k segment -s COLD -f green  -t "${cpu_temp}"$'\uE339' -i $'\uE350'
  fi
}

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
	os_icon
	context
	dir
	vcs
	newline
	prompt_char
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
	status
	command_execution_time
	background_jobs
	asdf
	virtualenv
	pyenv
	goenv
	nodenv
	nvm
	nodeenv
	node_version
	go_version
	php_version
	laravel_version
	java_version
	package
	luaenv
	jenv
	phpenv
	vim_shell
	vi_mode
	# ram
	# history
	load
	ip
	vpn_ip
	my_cpu_temp
	battery
	time
	newline
	kubecontext
	proxy
	# public_ip
)

typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION=' '
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION=' '
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION=''
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION=''

typeset -g P10K_SEGMENT_FG='#f9fafb'

# typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND='#2e7d32'
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND="$P10K_SEGMENT_FG"

typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND='#c62828'
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND="$P10K_SEGMENT_FG"

typeset -g POWERLEVEL9K_LOAD_NORMAL_BACKGROUND='#388e3c'
typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND="$P10K_SEGMENT_FG"

typeset -g POWERLEVEL9K_LOAD_WARNING_BACKGROUND='#f9a825'
typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND='#111827'

typeset -g POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND='#d32f2f'
typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND="$P10K_SEGMENT_FG"

typeset -g POWERLEVEL9K_VPN_IP_BACKGROUND='#00897b'
typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND="$P10K_SEGMENT_FG"

typeset -g POWERLEVEL9K_IP_BACKGROUND='#00acc1'
typeset -g POWERLEVEL9K_IP_FOREGROUND='#06252b'
typeset -g POWERLEVEL9K_IP_CONTENT_EXPANSION='${P9K_IP_IP}'

typeset -g POWERLEVEL9K_MY_CPU_TEMP_BACKGROUND='#283593'
typeset -g POWERLEVEL9K_MY_CPU_TEMP_FOREGROUND="$P10K_SEGMENT_FG"

typeset -g POWERLEVEL9K_BATTERY_BACKGROUND='#1e88e5'
typeset -g POWERLEVEL9K_BATTERY_FOREGROUND="$P10K_SEGMENT_FG"

typeset -g POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND='#43a047'
typeset -g POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND="$P10K_SEGMENT_FG"

typeset -g POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND='#2e7d32'
typeset -g POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND="$P10K_SEGMENT_FG"

typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND='#1976d2'
typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND="$P10K_SEGMENT_FG"

typeset -g POWERLEVEL9K_BATTERY_LOW_BACKGROUND='#f9a825'
typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND='#111827'

typeset -g POWERLEVEL9K_BATTERY_CRITICAL_BACKGROUND='#d32f2f'
typeset -g POWERLEVEL9K_BATTERY_CRITICAL_FOREGROUND="$P10K_SEGMENT_FG"

typeset -g POWERLEVEL9K_TIME_BACKGROUND='#29b6f6'
typeset -g POWERLEVEL9K_TIME_FOREGROUND='#0b1120'
typeset -g POWERLEVEL9K_TIME_FORMAT="%D{%H:%M %a}"

typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3

typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=''

typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='┈'

typeset -g POWERLEVEL9K_PROXY_VISUAL_IDENTIFIER_EXPANSION=''

typeset -g POWERLEVEL9K_PUBLIC_IP_HOST='http://ident.me'
typeset -g POWERLEVEL9K_PUBLIC_IP_METHODS=(curl)
typeset -g POWERLEVEL9K_PUBLIC_IP_TIMEOUT=10

unset POWERLEVEL9K_VPN_IP_CONTENT_EXPANSION
