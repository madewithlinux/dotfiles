#!/usr/bin/env bash

mouse_ids="$(xinput | awk -F'[=]' '/Razer Orochi/ {print $2}' | awk '{print $1}')"

# xinput set-prop $mouse_ids 'Device Accel Constant Deceleration' 3
for id in $mouse_ids; do
	xinput set-prop $id 'Device Accel Constant Deceleration' 1
	xinput set-prop $id 'Device Accel Velocity Scaling' 6
	xinput set-button-map $id  3 2 1 4 5 3 3 3 3
	echo $id
done
