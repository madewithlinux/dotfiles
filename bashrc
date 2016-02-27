# (c) Copyright 2014 Josh Wright
# ~/.bashrc
# ( symlinked from ~/Dropbox/.bashrc )

# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# attach to main tmux session if we are in guake, but only if we are not already in tmux
if [[ "$TERM" == "xterm-256color" && "$TMUX" == "" ]]; then
	exec tmux a -t main
fi
# make a new tmux if we're in st (because st doesn't have a scrollback buffer)
if [[ "$TERM" == "st-256color" && ! -e "$TMUX" ]]; then
	exec tmux
fi

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=5000

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
source ~/Dropbox/.tmux.completion.bash.txt
complete -cf sudo
complete -cf man

############
## basics ##
############
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
alias subl='subl3'
alias mpv='/usr/bin/mpv --hwdec=auto --profile=pseudo-gui --save-position-on-quit --cache=3145728 --input-unix-socket=/tmp/mpvsocket --ytdl-format=bestvideo+bestaudio'
alias ecryptfs='sudo mount -t ecryptfs -o ecryptfs_enable_filename_crypto=y,ecryptfs_cipher=aes,ecryptfs_key_bytes=32'
alias sensors='sensors -f'
alias mounted='mount|column -t'
alias exxit='kill -9 $$' # exit without writing history 
alias g++='g++ -std=gnu++11'
alias newmac='sudo macchanger -r wlp3s0 -b' # assign the wifi card a new random MAC address
alias yrt='yaourt'
alias yrt4='yaourt -aur-url https://aur4.archlinux.org'
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
alias cr='cmus-remote'
remove_detached_tmux() {
	# kills tmux sessions that are not attached and have only 1 window
	IFS=$'\n'
	for x in $(tmux ls |grep -v '(attached)'); do
		if [[ "$(echo $x|cut -f 2 -d ' ')" == "1" ]]; then
	        tmux kill-session -t "$(echo $x|cut -f 1 -d :)"
	    fi
	done
}


###################
## Long Commands ##
###################
alias fixmouse='xinput set-button-map "Logitech Unifying Device. Wireless PID:4013" 1 2 1 4 5 3 3 3 3 3 3;xinput set-button-map "USB Optical Wheel Mouse" 3 2 1 4 5 3 3 3 3 3 3;xinput --set-prop 10 "Device Accel Adaptive Deceleration" 2'
alias disableTouchpadInertiaScroll='xinput --set-prop --type=float "ETPS/2 Elantech Touchpad" "Synaptics Coasting Speed" 0 0'
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
source ~/Dropbox/.bashrc_private # stuff that doesn't belong on a public git
export PATH="$HOME/Dropbox/bin:$HOME/.local/bin:$HOME/.npm-packages/bin:$HOME/.gem/ruby/2.2.0/bin:$PATH:/opt/MATLAB/bin"
export EDITOR="nvim"
export TEXINPUTS=".:/home/j0sh/Dropbox/code/LaTeX/sty:"
# need this for tmux to use 256 colors
if [[ "$TERM" = "xterm" ]]; then
	export TERM="xterm-256color"
fi
# allow us to set title in tmux
if [[ "$TMUX" != "" ]]; then
	title() {
		tmux set -g set-titles-string "$*"
	}
fi


##################
## Prompt Stuff ##
##################
# the actual powerline script causes tiny but noticeable lag for me
# must wrap escape colors inside \[\] or else the current line doesn't wrap to the next one correctly
# (because terminals are weird)
COLOR_BG="\[\e[48;5;237m\]"
COLOR_FG="\[\e[38;5;237m\]"
COLOR_TIME="\[\e[1;32m\]"
COLOR_USER="\[\e[1;34m\]"
COLOR_PATH="\[\e[1;35m\]"
COLOR_NONE="\[\e[0m\]"
POWERLINE_ARROW=""
PS1="${COLOR_USER}\u${COLOR_PATH}\W${COLOR_NONE}${COLOR_FG}${POWERLINE_ARROW}${COLOR_NONE} "
PS1_static=$PS1
PROMPT_COMMAND='PS1="${COLOR_BG}${COLOR_TIME}$(date +%I:%M%p)${PS1_static}"'
