#!/usr/bin/env bash
# (c) Copyright 2015 Josh Wright

touchpad_name="SynPS/2 Synaptics TouchPad"

enabled="$(xinput list-props "$touchpad_name"|grep "Device Enabled" |sed -e 's/.*\:[ \t]\+//g')"

if [[ "$enabled" == "1" ]]; then
	xinput set-prop "$touchpad_name" "Device Enabled" 0
else
	xinput set-prop "$touchpad_name" "Device Enabled" 1
fi