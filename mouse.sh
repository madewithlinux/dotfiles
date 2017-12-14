#!/usr/bin/env bash

mouse_id="$(xinput | awk -F'[=]' '/Razer Orochi/ {print $2}' | awk '{print $1}' |tail -n 1)"

# xinput set-prop $mouse_id 'Device Accel Constant Deceleration' 3
xinput set-prop $mouse_id 'Device Accel Constant Deceleration' 2
xinput set-button-map $mouse_id  3 2 1 4 5 3 3 3 3
