#!/bin/bash
# ddcutil_backlight_inc.sh
set -e -x -o pipefail

ddcutil setvcp 10 $(( $(ddcutil getvcp 10 -t|cut -f4 -d' ') $1))
