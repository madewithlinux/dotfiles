// (c) Copyright 2015 Josh Wright
// controls the fan speed on my Thinkpad T450s
// (may or may not work on yours)
#include <iostream>
#include <fstream>

using std::string;
using std::cout;
using std::endl;

constexpr const char *fan_socket_path = "/proc/acpi/ibm/fan";

void print_help(const char *name) {
  cout << "Usage: " << name << " <level>" << endl;
  cout << "Valid levels are:" << endl;
  cout << "0-7, auto, disengaged, full-speed" << endl;
}

void set_fan_level(const string level) {
  std::ofstream output(fan_socket_path);
  output << "level " << level << endl;
}

int main(int argc, char const *argv[]) {
  if (argc < 1) {
    print_help(argv[0]);
    return 0;
  }
  switch (*argv[1]) {
    case '0':
      set_fan_level("0");
      break;
    case '1':
      set_fan_level("1");
      break;
    case '2':
      set_fan_level("2");
      break;
    case '3':
      set_fan_level("3");
      break;
    case '4':
      set_fan_level("4");
      break;
    case '5':
      set_fan_level("5");
      break;
    case '6':
      set_fan_level("6");
      break;
    case '7':
      set_fan_level("7");
      break;
    case 'a':
      set_fan_level("auto");
      break;
    case 'd':
      set_fan_level("disengaged");
      break;
    case 'f':
      set_fan_level("full-speed");
      break;
    default:
      print_help(argv[0]);
      break;
  }
  return 0;
}
