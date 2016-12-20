# (c) Copyright 2014 Josh Wright
# ~/.bashrc
# ( symlinked from ~/Dropbox/.bashrc )

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=50000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# tab-completion:
if [[ -f "$HOME/Dropbox/.tmux.completion.bash.txt" ]]; then
	source "$HOME/Dropbox/.tmux.completion.bash.txt"
fi
	
complete -cf sudo
complete -cf man

############
## basics ##
############
binary_exists() { 
	[ -n "$(which $1 2>/dev/null)" ]
}
file_exists() { 
	[ -f "$1" ] 
}
alias grep='grep --color=auto'
alias dstat='dstat -cdnmD sda,sdb,sdc,sdd,sde,sdf,sdg,sdh,sdi,sdj,sdk,sdl,sdm,sdl,sdo,sdp,sr0,mmcblk0p1'
alias lsblk='lsblk --output NAME,MODEL,LABEL,SIZE,TYPE,FSTYPE,MOUNTPOINT,UUID'
alias ls='ls --color=auto'
alias ll='ls -lFh --color=auto'
alias l='ls -alF --color=auto'
alias df='df -h'
alias du='du -hs'
alias htop='htop -d 10'
alias ncdu='ncdu -x'
alias pstree='pstree -U'
binary_exists subl3 && alias subl='subl3'
alias mpv='/usr/bin/mpv --hwdec=auto --profile=pseudo-gui --save-position-on-quit --cache=3145728 --input-unix-socket=/tmp/mpvsocket --ytdl-format=bestvideo+bestaudio'
alias ecryptfs='sudo mount -t ecryptfs -o ecryptfs_enable_filename_crypto=y,ecryptfs_cipher=aes,ecryptfs_key_bytes=32'
alias sensors='sensors -f'
alias mounted='mount|column -t'
alias exxit='kill -9 $$' # exit without writing history 
alias newmac='sudo macchanger -r wlp3s0 -b' # assign the wifi card a new random MAC address
alias empty_trash='rm -rf ~/.local/share/Trash/'
alias copy='xsel -ib'
alias paste='xsel -ob'
alias qr='paste|qrencode -t ANSI -m 2'
alias qrimage='xsel -ob|qrencode -t PNG -o - -s 80|feh -Z - -.'
alias copyTime='date "+%Y/%m/%d %I:%M:%S %p"|xsel -ib'
alias updatedb='sudo updatedb'
alias powertop='sudo powertop'
alias drop_caches='echo 3 |sudo tee /proc/sys/vm/drop_caches'
alias youtube-dl='youtube-dl -ci'
alias ytdl='youtube-dl "$(xsel -ob)"'
# not sure why jupyter doesn't work unless you specify the ip manually
alias jnb='jupyter notebook --ip 127.0.0.1'
alias wtitle='tmux rename-window'
alias tmxls='tmux ls |column -t'
remove_detached_tmux() {
	# kills tmux sessions that are not attached and have only 1 window
	IFS=$'\n'
	# if it isn't attached
	for x in $(tmux ls |grep -v '(attached)'); do
		# if it only has 1 window
		if [[ "$(echo $x|cut -f 2 -d ' ')" == "1" ]]; then
			# tell tmux to kill it
	        tmux kill-session -t "$(echo $x|cut -f 1 -d :)"
	    fi
	done
}


###################
## Long Commands ##
###################
alias fixmouse='xinput set-button-map "Logitech Unifying Device. Wireless PID:4013" 1 2 1 4 5 3 3 3 3 3 3;xinput set-button-map "USB Optical Wheel Mouse" 3 2 1 4 5 3 3 3 3 3 3;xinput --set-prop 10 "Device Accel Adaptive Deceleration" 2'
# the first call to xrandr is necessary so that the second one has any effect
alias fixdisplay='xrandr --output HDMI1 --pos 1920x56 && xrandr --output HDMI1 --primary --auto --left-of eDP1'
alias disableTouchpadInertiaScroll='xinput --set-prop --type=float "SynPS/2 Synaptics TouchPad" "Synaptics Coasting Speed" 0 0'
alias matrix='startx /usr/lib/xscreensaver/xmatrix -no-knock-knock -no-trace -ascii -small -root -- :1'
alias lcdscrub='startx /usr/lib/xscreensaver/lcdscrub -spread 10 -delay 50000 -cycles 30 -root -- :1'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias  cpu_min='sudo cpupower frequency-set -u 900mHz; sudo cpupower frequency-set -d 500mHz'
alias  cpu_max='sudo cpupower frequency-set -u 2.7Ghz; sudo cpupower frequency-set -d 500mHz'
alias cpu_info='sudo cpupower frequency-info'
alias          fan_level_0='echo level 0          | sudo tee /proc/acpi/ibm/fan # (fan off)'
alias          fan_level_2='echo level 2          | sudo tee /proc/acpi/ibm/fan # (low speed)'
alias          fan_level_4='echo level 4          | sudo tee /proc/acpi/ibm/fan # (medium speed)'
alias          fan_level_7='echo level 7          | sudo tee /proc/acpi/ibm/fan # (maximum speed)'
alias       fan_level_auto='echo level auto       | sudo tee /proc/acpi/ibm/fan # (automatic - default)'
alias fan_level_disengaged='echo level disengaged | sudo tee /proc/acpi/ibm/fan # (disengaged)'
alias build_server='ssh -X j0sh@linux.cse.tamu.edu'
alias build_server_fs='mkdir -p /tmp/build_server; sshfs j0sh@build.tamu.edu:/home/ugrads/j/j0sh /tmp/build_server'
alias tamu_only_vpn='sudo openconnect connect.tamu.edu --authgroup tunnel_tamu_traffic --user=j0sh'
mpv_get_time() {
	echo '{ "command": ["get_property", "time-pos"] }'       |socat - /tmp/mpvsocket |python -c 'import sys,json; print(json.load(sys.stdin)["data"])'
}
mpv_set_time() {
	echo '{ "command": ["set_property", "time-pos", '$1'] }' |socat - /tmp/mpvsocket
}
mpv_pause() {
	echo '{ "command": ["set_property", "pause", true] }'    |socat - /tmp/mpvsocket
}
mpv_quit() {
	echo '{ "command": ["quit"] }'                           |socat - /tmp/mpvsocket
}


#########################
## Paths and constants ##
#########################
file_exists "$HOME/Dropbox/.bashrc_private" && source "$HOME/Dropbox/.bashrc_private" # stuff that doesn't belong on a public git
file_exists "$HOME/.bashrc_local" && source "$HOME/.bashrc_local" # system-specific stuff
export PATH="$PATH:/sbin:/usr/sbin"
export PATH="$HOME/Dropbox/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.cabal/bin:$PATH"
export PATH="/opt/cabal/1.24/bin:/opt/happy/1.19.5/bin:/opt/alex/3.1.7/bin:$PATH"
export PATH="/opt/cmake/bin:$PATH"
export PATH="/opt/ghc/8.0.1/bin/:$PATH"
# export PATH="/opt/ghc/7.10.3/bin:$PATH"
# for ease of navigation
export CODE="$HOME/Dropbox/code"
export DOTFILES="$HOME/Dropbox/dotfiles"
export TAMU="$HOME/Dropbox/Tablet/TAMU"
# export PATH="/opt/cmake/bin:/opt/ghc/7.10.3/bin/:$PATH"
export EDITOR="vim"
export TERMINAL="st"
export TEXINPUTS=".:/home/j0sh/Dropbox/code/LaTeX/sty:"
# need this for tmux to use 256 colors
if [[ "$TERM" = "xterm" ]]; then
	export TERM="xterm-256color"
fi

# allow us to set title in tmux
title() {
	if [[ "$TMUX" != "" ]]; then
		tmux set -g set-titles-string "$*"
	else
		echo -en "\033]0;${*}\a"
	fi
}
build_tex() {
    mkdir -p .latex
    pdflatex --halt-on-error -output-directory=.latex -aux-directory=.latex $1
    echo "${1%.tex}.pdf"
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile="${1%.tex}.pdf" .latex/"${1%.tex}.pdf"
}
watch_tex() {
    # find $1 -name '*.tex' -execdir bash -c 'echo watching {}; (while inotifywait {} ; do pdflatex -output-directory=.latex --halt-on-error -aux-directory=.latex {}; done) &' \{\} ';';
    echo "${1%.tex}.pdf"
    while inotifywait $1; do
        mkdir -p .latex
        pdflatex --halt-on-error -output-directory=.latex -aux-directory=.latex $1
        echo "${1%.tex}.pdf"
	    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile="${1%.tex}.pdf" .latex/"${1%.tex}.pdf"
    done
}

# make the printPrtSc key into a menu key
binary_exists xmodmap && [[ -n "$DISPLAY" ]] && xmodmap -e "keycode 107 = Menu NoSymbol Menu"



##################
## Prompt Stuff ##
##################
# the actual powerline script causes tiny but noticeable lag for me
# must wrap escape colors inside \[\] or else the current line doesn't wrap to the next one correctly
# (because terminals are weird)
COLOR_RED_BOLD="\[\e[1;33m\]"
# COLOR_BG="\[\e[48;5;252m\]"
COLOR_BG="\[\e[47m\]"
COLOR_TIME="\[\e[1;32m\]"
if [[ "$USER" == "root" ]]; then
	COLOR_USER="\[\e[1;31m\]"
else
	COLOR_USER="\[\e[1;34m\]"
fi
COLOR_PATH="\[\e[1;35m\]"
COLOR_NONE="\[\e[0m\]"
PS1="${COLOR_USER}\u${COLOR_RED_BOLD}@${COLOR_USER}\h${COLOR_PATH}\W${COLOR_NONE}${POWERLINE_ARROW}${COLOR_NONE} "
PS1_static=$PS1
PROMPT_COMMAND='PS1="${COLOR_BG}${COLOR_TIME}$(date +%I:%M%p)${PS1_static}"'

