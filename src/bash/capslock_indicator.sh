#!/usr/bin/env bash
# relies on power_light being set-uid root

interval="0.1"

while xset -q|grep "Caps Lock:   on"; do
    /power_light 0
    sleep $interval;
    /power_light 1
    sleep $interval;
done