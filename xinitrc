# (c) Copyright 2016 Josh Wright
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

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
feh --bg-scale /home/j0sh/Dropbox/wallpaper.png
# disable touch pad inertial scroll
xinput --set-prop --type=float "SynPS/2 Synaptics TouchPad" "Synaptics Coasting Speed" 0 0
# xautolock -time 10 -lockaftersleep -locker "/home/j0sh/Dropbox/bin/lock_screen_with_i3lock.sh" &
# xss-lock -- "/home/j0sh/Dropbox/bin/lock_screen_with_i3lock.sh" &

exec awesome 2>.awesome.log
#exec i3 2>.i3log
exit

# dwm specific stuff
# status bar refreshing
# (while true; do xsetroot -name "$(/home/j0sh/Dropbox/dotfiles/dwm/dwm_status_display.py)"; sleep 0.016s; done) &
# /home/j0sh/Dropbox/dotfiles/dwm/dwm_status_display.py &
# wmname LG3D
# export __GL_SYNC_TO_VBLANK=1
# # restart for recompiling
# while true; do
#     # Log stderror to a file 
#     /home/j0sh/Dropbox/dotfiles/dwm/dwm 2> ~/.dwm.log
#     # No error logging
#     #/home/j0sh/Dropbox/dotfiles/dwm/dwm >/dev/null 2>&1
# done
