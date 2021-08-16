xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Primary><Shift>F1' --set move_window_workspace_1_key -t string --create
xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Primary><Shift>F2' --set move_window_workspace_2_key -t string --create
xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Primary><Shift>F3' --set move_window_workspace_3_key -t string --create
xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Primary><Shift>F4' --set move_window_workspace_4_key -t string --create
xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Primary><Shift>F5' --set move_window_workspace_5_key -t string --create
xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Primary><Shift>F6' --set move_window_workspace_6_key -t string --create
xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Primary><Shift>F7' --set move_window_workspace_7_key -t string --create
xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Primary><Shift>F8' --set move_window_workspace_8_key -t string --create
xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Primary><Shift>F9' --set move_window_workspace_9_key -t string --create
xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Primary><Shift>F10' --set move_window_workspace_10_key -t string --create
xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Primary><Shift>F11' --set move_window_workspace_11_key -t string --create
xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Primary><Shift>F12' --set move_window_workspace_12_key -t string --create

xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Shift><Super>Left' --set tile_up_left_key --create -t string
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Shift><Super>Right' --set tile_up_right_key --create -t string
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Super>Left' --set tile_down_left_key --create -t string
xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Primary><Super>Right' --set tile_down_right_key --create -t string

# you have to reset F7 because that is set to maximize_window_key  by default, and having two entries for the same thing confuses it apparently
xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Alt>F7' --reset
xfconf-query --channel xfce4-keyboard-shortcuts --property '/xfwm4/custom/<Alt>F10' --set maximize_window_key --create -t string
