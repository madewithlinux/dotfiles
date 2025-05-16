#!/usr/bin/env python3

import subprocess
import re
import sys

# Get active/focused window
out = subprocess.check_output(['xprop', '-root', '_NET_ACTIVE_WINDOW']).decode('ascii', 'ignore')
# print(out)
list_id = [re.search("window id # (0x[0-9a-f]+)", out).group(1)]
id = list_id[0]

wm_class_ret = subprocess.check_output(['xprop', '-id', id, 'WM_CLASS']).decode('ascii', 'ignore')


# Get screens information and order them
# ======================================
# scr will store a list of list: [ [ width height offset_x offset_y ] ... ]
out = subprocess.check_output(['xrandr']).decode('ascii', 'ignore')
reg = re.compile(" connected( primary)? ([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+)")
scr = []
for l in out.splitlines():
	m = reg.search(l)
	if m:
		scr += [ list(map(int, m.groups()[1:])) ]

print(f'{scr=}')

# TODO: generify this if/when I change monitors
assert len(scr) == 2
assert scr == [[2560, 2880, 0, 0], [2560, 2880, 2560, 0]]

full_width = 2560*2
full_height = 2880


# TODO: find a way to determine these values programmatically
taskbar_buffer = 0
x = 0
y = 0
margin_x = 10
margin_y = 98

if "firefox_firefox" in wm_class_ret:
	# ugly hack to fix firefox
	x = -50
	margin_x = -100
	margin_y = -49
elif "google-chrome" in wm_class_ret:
	# ugly hack to fix chrome
	margin_x = -1
	margin_y = 50

full_width -= margin_x
full_height -= margin_y
# move and resize the window
cmd = ['wmctrl', '-i', '-r', id, '-e', f'0,{x},{y+taskbar_buffer},{full_width},{full_height-taskbar_buffer}']
print(f'{cmd=}')
subprocess.call(cmd)
