# (c) Copyright 2016 Josh Wright
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# twm &
# xclock -geometry 50x50-1+1 &
# xterm -geometry 80x50+494+51 &
# xterm -geometry 80x20+494-0 &
# exec xterm -geometry 80x66+0+0 -name login

## some applications that should be run in the background
# xscreensaver &
# xsetroot -cursor_name left_ptr &
xset b off 
xfsettingsd &
clipit &
dropbox &
nm-applet &
# wicd-gtk -t &
xfce4-power-manager &
# xautolock -time 10 -lockaftersleep -locker "/home/j0sh/Dropbox/bin/lock_screen_with_i3lock.sh" &
# xss-lock -- "/home/j0sh/Dropbox/bin/lock_screen_with_i3lock.sh" &

# exec openbox-session
# exec xfce4-session
# exec gnome-session

#exec awesome

# dwm specific stuff
# status bar refreshing
(while true; do xsetroot -name "$(/home/j0sh/Dropbox/dotfiles/dwm/dwm_status_display.py)"; sleep 1; done) &
# restart for recompiling
while true; do
    # Log stderror to a file 
    /home/j0sh/Dropbox/dotfiles/dwm/dwm 2> ~/.dwm.log
    # No error logging
    #/home/j0sh/Dropbox/dotfiles/dwm/dwm >/dev/null 2>&1
done