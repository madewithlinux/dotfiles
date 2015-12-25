// (c) Copyright 2015 Josh Wright
// can toggle the power light of my Thinkpad T450s on kernel 4.3.3-ck
#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
/*
g++    -std=gnu++14     power_light.cpp -o power_light
g++ -g -std=gnu++14 -O0 power_light.cpp -o power_light
g++ -g -std=gnu++14 -O3 power_light.cpp -o power_light
*/

const std::string power_light_device_path("/sys/devices/platform/thinkpad_acpi/leds/tpacpi::power/brightness");

int main(int argc, char const *argv[])
{
	if (argc < 2) {
		return 1;
	}
	std::ofstream out(power_light_device_path);
	out.write(argv[1], std::strlen(argv[1]));
	return 0;
}
