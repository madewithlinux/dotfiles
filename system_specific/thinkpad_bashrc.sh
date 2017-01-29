# (c) Copyright 2017 Josh Wright

###################
## Long Commands ##
###################
alias          fan_level_0='echo level 0          | sudo tee /proc/acpi/ibm/fan # (fan off)'
alias          fan_level_2='echo level 2          | sudo tee /proc/acpi/ibm/fan # (low speed)'
alias          fan_level_4='echo level 4          | sudo tee /proc/acpi/ibm/fan # (medium speed)'
alias          fan_level_7='echo level 7          | sudo tee /proc/acpi/ibm/fan # (maximum speed)'
alias       fan_level_auto='echo level auto       | sudo tee /proc/acpi/ibm/fan # (automatic - default)'
alias fan_level_disengaged='echo level disengaged | sudo tee /proc/acpi/ibm/fan # (disengaged)'
alias  cpu_min='sudo cpupower frequency-set -u 900mHz; sudo cpupower frequency-set -d 500mHz'
alias  cpu_max='sudo cpupower frequency-set -u 2.7Ghz; sudo cpupower frequency-set -d 500mHz'
alias cpu_info='sudo cpupower frequency-info'

