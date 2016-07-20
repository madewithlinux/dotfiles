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
xfce4-power-manager &
# xautolock -time 10 -lockaftersleep -locker "/home/j0sh/Dropbox/bin/lock_screen_with_i3lock.sh" &
# xss-lock -- "/home/j0sh/Dropbox/bin/lock_screen_with_i3lock.sh" &

# exec openbox-session
# exec xfce4-session
exec awesome
# exec gnome-session
