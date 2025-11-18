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
	ssh
	root_indicator
	command_execution_time
	background_jobs
	direnv
	asdf
	virtualenv
	anaconda
	pyenv
	goenv
	nodenv
	php_version
	laravel_version
	nvm
	nodeenv
	go_version
	rbenv
	rvm
	luaenv
	jenv
	plenv
	phpenv
	scalaenv
	haskell_stack
	terraform
	ranger
	nnn
	xplr
	vim_shell
	midnight_commander
	nix_shell
	vi_mode
	todo
	timewarrior
	taskwarrior
	ram
	load
	# history
	time
	newline
	kubecontext
	proxy
	public_ip
	vpn_ip
	ip
	my_cpu_temp
	battery
)

typeset -g POWERLEVEL9K_MY_CPU_TEMP_BACKGROUND=233

# typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#52b69a'
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
# typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=235
# typeset -g POWERLEVEL9K_DIR_BACKGROUND=#1e6091
# typeset -g POWERLEVEL9K_DIR_FOREGROUND=235
# typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND='#1296C5'
# typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=236
# typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION=''
# typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION='' 
# typeset -g POWERLEVEL9K_HISTORY_BACKGROUND='#1e6091'
# typeset -g POWERLEVEL9K_HISTORY_FOREGROUND=233
typeset -g POWERLEVEL9K_IP_CONTENT_EXPANSION='${P9K_IP_IP}'
# typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_BACKGROUND=141
# typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=234
# typeset -g POWERLEVEL9K_LOAD_NORMAL_BACKGROUND=#1a759f
# typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=#1296C5
typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=''
# typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=234
# typeset -g POWERLEVEL9K_PROXY_BACKGROUND=#34a0a4
# typeset -g POWERLEVEL9K_PROXY_FOREGROUND=234
typeset -g POWERLEVEL9K_PROXY_VISUAL_IDENTIFIER_EXPANSION=''
typeset -g POWERLEVEL9K_PUBLIC_IP_BACKGROUND=233
# typeset -g POWERLEVEL9K_PUBLIC_IP_FOREGROUND=234
typeset -g POWERLEVEL9K_PUBLIC_IP_HOST='http://ident.me'
typeset -g POWERLEVEL9K_PUBLIC_IP_METHODS=(curl)
typeset -g POWERLEVEL9K_PUBLIC_IP_TIMEOUT=10
# typeset -g POWERLEVEL9K_ROOT_ICON=""
# typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=┈
# typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND='#283618'
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='#43aa8b'
# typeset -g POWERLEVEL9K_STATUS_OK_PIPE_BACKGROUND=24
# typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=2
# typeset -g POWERLEVEL9K_SUDO_ICON=" "
# typeset -g POWERLEVEL9K_TIME_BACKGROUND='#184e77'
# typeset -g POWERLEVEL9K_TIME_FOREGROUND='#93a2ba'
typeset -g POWERLEVEL9K_TIME_FORMAT="%D{%H:%M %a}"
# typeset -g POWERLEVEL9K_USER_ICON="" #""
# typeset -g POWERLEVEL9K_VPN_IP_BACKGROUND='#168aad'
unset POWERLEVEL9K_VPN_IP_CONTENT_EXPANSION

# -- left --
# typeset -g POWERLEVEL9K_BATTERY_BACKGROUND=55
# typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=┈
# typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION=✓
# typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION=✓
# typeset -g POWERLEVEL9K_TIME_BACKGROUND=105
# typeset -g POWERLEVEL9K_VPN_IP_INTERFACE='(gpd|wg|ppp0|(.*tun)|tailscale)[0-9]*'