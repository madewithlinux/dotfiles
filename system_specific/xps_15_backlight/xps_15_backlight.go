package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
)

const brightnessPath = "/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight/brightness"
const delta = 1000

/**
build:

go build xps_15_backlight.go
mv -f xps_15_backlight ~/bin/
sudo chown root:root ~/bin/xps_15_backlight
sudo chmod u+s ~/bin/xps_15_backlight

*/

func main() {
	// get previous brightness
	text, err := ioutil.ReadFile(brightnessPath)
	die(err)
	brightness, err := strconv.Atoi(strings.Trim(string(text), "\n \t"))
	die(err)

	// modify
	if os.Args[1] == "up" {
		brightness += delta
	} else {
		brightness -= delta
	}

	// write it back
	err = ioutil.WriteFile(brightnessPath, []byte(fmt.Sprintln(brightness)), 0644)
	die(err)
}

func die(err error) {
	if err != nil {
		panic(err)
	}
}
