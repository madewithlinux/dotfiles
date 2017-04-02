package main

import (
	"fmt"
	"github.com/godbus/dbus"
	"io/ioutil"
	"path/filepath"
	"strconv"
	"time"
)

const (
	DBUS_UPOWER_PATH      = "org.freedesktop.UPower"
	BATTERY_PATH          = "/org/freedesktop/UPower/devices/DisplayDevice"
	PROP_TIME_TO_EMPTY    = "org.freedesktop.UPower.Device.TimeToEmpty"
	PROP_PERCENTAGE       = "org.freedesktop.UPower.Device.Percentage"
	TEMPERATURE_GLOB_PATH = "/sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input"
)

func main() {

	temp_c, temp_f := get_temp()
	time_remaining, percentage := get_battery_info()
	current_time := time.Now().Format("2006-01-02 3:04PM Mon")

	fmt.Printf("%3.1fC %3.1fF %.1f%% %.1fh %s", temp_c, temp_f, percentage, time_remaining, current_time)

}

func check(err error) {
	if err != nil {
		panic(err)
	}
}

func get_temp() (c, f float64) {
	matches, err := filepath.Glob(TEMPERATURE_GLOB_PATH)
	check(err)
	contents, err := ioutil.ReadFile(matches[0])
	check(err)
	// trim off last byte (newline) of input
	contents_str := string(contents[:len(contents)-1])
	t, err := strconv.ParseFloat(contents_str, 64)
	check(err)
	// convert from celsius to fahrenheit
	c = t / 1000.0
	f = c*9.0/5.0 + 32.0
	return
}

func get_battery_info() (time_remaining, percentage float64) {
	conn, err := dbus.SystemBus()
	check(err)
	obj := conn.Object(DBUS_UPOWER_PATH, dbus.ObjectPath(BATTERY_PATH))

	time_v, err := obj.GetProperty(PROP_TIME_TO_EMPTY)
	check(err)
	time_remaining_int, _ := time_v.Value().(int64)
	time_remaining = float64(time_remaining_int) / 3600.0

	percentage_v, err := obj.GetProperty(PROP_PERCENTAGE)
	check(err)
	percentage, _ = percentage_v.Value().(float64)
	return
}
