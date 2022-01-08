# (c) Copyright 2020 Josh Wright
# bashrc

if [[ "$MARKER_BASH_PROFILE" != "7" ]]; then
    . "$HOME/.bash_profile"
fi
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=500000
HISTFILESIZE=500000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# allow recursive globbing
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable vte terminal features for tilix, such as working directory integration
if [ $TILIX_ID ] || [ $VTE_VERSION ] ; then
   [[ -f '/etc/profile.d/vte.sh' ]] && source /etc/profile.d/vte.sh
   [[ -f '/etc/profile.d/vte-2.91.sh' ]] && source /etc/profile.d/vte-2.91.sh
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# tab-completion:
if [[ -f "$HOME/Dropbox/.tmux.completion.bash.txt" ]]; then
    source "$HOME/Dropbox/.tmux.completion.bash.txt"
fi
if [[ -f "/usr/local/etc/bash_completion.d/deno.bash" ]]; then
    source "/usr/local/etc/bash_completion.d/deno.bash"
fi

complete -cf sudo
complete -cf man

############
## basics ##
############
alias grep='grep --color=auto'
alias dstat='dstat -cdnmD sda,sdb,sdc,sdd,sde,sdf,sdg,sdh,sdi,sdj,sdk,sdl,sdm,sdl,sdo,sdp,sr0,mmcblk0p1,nvme0n1'
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
# alias mpv='/usr/bin/mpv --hwdec=auto --profile=pseudo-gui --save-position-on-quit --cache=3145728 --input-unix-socket=/tmp/mpvsocket --ytdl-format=bestvideo+bestaudio'
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
alias copyTime='echo -n `date "+%Y/%m/%d %I:%M:%S %p"`|xsel -ib'
alias filenameDate='echo -n `date "+%Y%m%d-%H%M%S"`|xsel -ib; date "+%Y%m%d-%H%M%S"'
alias updatedb='sudo updatedb'
alias powertop='sudo powertop'
alias drop_caches='echo 3 |sudo tee /proc/sys/vm/drop_caches'
alias youtube-dl='youtube-dl -ci'
alias ytdl='youtube-dl "$(xsel -ob)"'
# not sure why jupyter doesn't work unless you specify the ip manually
alias jnb='jupyter notebook --ip 127.0.0.1'
alias wtitle='tmux rename-window'
alias tmxls='tmux ls |column -t'

###################
## Long Commands ##
###################
alias fixmouse='xinput set-button-map "Logitech Unifying Device. Wireless PID:4013" 1 2 1 4 5 3 3 3 3 3 3;xinput set-button-map "USB Optical Wheel Mouse" 3 2 1 4 5 3 3 3 3 3 3;xinput --set-prop 10 "Device Accel Adaptive Deceleration" 2'
# the first call to xrandr is necessary so that the second one has any effect
alias disableTouchpadInertiaScroll='xinput --set-prop --type=float "SynPS/2 Synaptics TouchPad" "Synaptics Coasting Speed" 0 0'
alias matrix='startx /usr/lib/xscreensaver/xmatrix -no-knock-knock -no-trace -ascii -small -root -- :1'
alias lcdscrub='startx /usr/lib/xscreensaver/lcdscrub -spread 10 -delay 50000 -cycles 30 -root -- :1'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias build_server='ssh -X j0sh@linux.cse.tamu.edu'
alias build_server_fs='mkdir -p /tmp/build_server; sshfs j0sh@build.tamu.edu:/home/ugrads/j/j0sh /tmp/build_server'
alias tamu_only_vpn='sudo openconnect connect.tamu.edu --authgroup tunnel_tamu_traffic --user=j0sh'

################
## functions  ##
################
# allow us to set title in tmux
__USER_SET_TITLE=0
title() {
    if [[ "$TMUX" != "" ]]; then
        tmux set set-titles-string "$*"
    else
        echo -en "\033]0;${*}\a"
    fi
    __USER_SET_TITLE=1
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


##################
## Prompt Stuff ##
##################
# the actual powerline script causes tiny but noticeable lag for me
# must wrap escape colors inside \[\] or else the current line doesn't wrap to the next one correctly
# (because terminals are weird)
COLOR_RED_BOLD="\[\e[1;33m\]"
# COLOR_BG="\[\e[48;5;252m\]"
COLOR_BG="\[\e[48;5;237m\]"
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
function _prompt_command() {
    if type __vte_prompt_command >/dev/null 2>&1; then
      __vte_prompt_command
    fi
    if [[ -n $VIRTUAL_ENV ]]; then
      # in virtual env
      PS1="${COLOR_BG}${COLOR_TIME}$(date +%I:%M%p)${COLOR_USER}\u${COLOR_RED_BOLD}@${COLOR_USER}\h${COLOR_PATH}\W${COLOR_USER}*${COLOR_NONE} "
    else
      PS1="${COLOR_BG}${COLOR_TIME}$(date +%I:%M%p)${PS1_static}"
    fi
    if [[ $__USER_SET_TITLE == 0 ]]; then
        # title "$USER@$(hostname):$(basename $(pwd))"
        title "$(basename "$(pwd)")"
        __USER_SET_TITLE=0
    fi
}
PROMPT_COMMAND=_prompt_command

source_if_exists "/usr/share/modules/init/bash"
if type module > /dev/null 2>&1; then
    module load use.own
fi
source_if_exists "$HOME/.bashrc_local"
source_if_exists "$HOME/.just.bash"

export FZF_COMPLETION_TRIGGER='~~'
export FZF_DEFAULT_OPTS='--bind ctrl-d:page-down,ctrl-u:page-up'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# added by travis gem
[ ! -s /home/j0sh/.travis/travis.sh ] || source /home/j0sh/.travis/travis.sh

PATH=$PATH:/home/j0sh/Applications/010Editor;export PATH; # ADDED BY INSTALLER - DO NOT EDIT OR DELETE THIS COMMENT - 87FF8EFC-483D-BCAA-D67D-735CF60410D1 C457BCDB-5EE4-2D8E-FDD6-571893CC3981

export PATH=$PATH:/home/j0sh/.platformio/penv/bin/


