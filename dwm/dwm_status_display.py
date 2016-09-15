#!/usr/bin/env python
# Copyright (c) 2015 Josh Wright
# This is the script that I use for my tmux status window
# run "tmux refresh-client -S" to force update the status bar
# ref: http://tuxdiary.com/2015/09/14/power-battery-status/


import sys, os
from time import time
import datetime
import dbus

# config options:

# time format
time_fmt = "%Y-%m-%d %I:%M%p %a"

# Unicode Constants:
down_arrow = "\uf152"
up_arrow = "\uf153"
# checkmark = "\u2713"
checkmark = "\uf00c"
x_mark = "x"
x_mark = "\u2717"
# sync_icon = "\uf07d"
# sync_icon = "\u27f3"
sync_icon = "\uf0c8"
dropbox = "\ue707"

composite_battery_path = '/org/freedesktop/UPower/devices/DisplayDevice'



############

dbus_upower_path = 'org.freedesktop.UPower'
dbus_properties_path = 'org.freedesktop.DBus.Properties'

to_print = ""
temp = 0
for i in range(10):
	# don't know why this number changes occasionally, but this fixes it
	try:
		with open("/sys/devices/platform/coretemp.0/hwmon/hwmon"+str(i)+"/temp1_input", 'r') as f:
			# convert Celsius -> Fahrenheit
			temp = int(f.read()) / 1000 * 9/5 + 32
			break;
	except:
		pass

system_bus = dbus.SystemBus()
battery_object = system_bus.get_object(dbus_upower_path, composite_battery_path)
battery_properties_interface = dbus.Interface(battery_object, dbus_properties_path)
# battery_properties_interface = dbus.Interface(battery_object, dbus_upower_path)
battery_properties = battery_properties_interface.GetAll("org.freedesktop.UPower.Device")
battery_precent = int(battery_properties["Percentage"])
battery_time = round(battery_properties["TimeToEmpty"] / 3600,1)

to_print += str(temp) + "F"
to_print += " "
to_print += str(battery_precent) + "%"
to_print += " "
to_print += str(battery_time) + "h"
to_print += " "
to_print += datetime.datetime.now().strftime(time_fmt)
# to_print += datetime.time.n

print(to_print, end='')
