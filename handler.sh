#!/bin/bash
# Default acpi script that takes an entry for all actions

# 1 for true, 0 for false
plugged_in=$(cat /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:08/PNP0C09:00/ACPI0003:00/power_supply/AC/online)
lid_open=$(cat /proc/acpi/button/lid/LID/state |grep closed > /dev/null; echo $?)
lock() {
    DISPLAY=:0.0 su j0sh -c /home/j0sh/Dropbox/bin/lock_screen_with_i3lock.sh &
}
suspend() {
	systemctl suspend
}

# echo $* >> /tmp/acpid.log

case "$1" in
    button/power)
        case "$2" in
            PBTN|PWRF)
                logger 'PowerButton pressed'
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    button/sleep)
        case "$2" in
            SLPB|SBTN)
                logger 'SleepButton pressed'
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    ac_adapter)
        case "$2" in
            AC|ACAD|ADP0|ACPI0003:00)
                case "$4" in
                    00000000)
                        logger 'AC unpluged'
                        if [[ "$lid_open" == "0" ]]; then
                            logger 'suspending: unplugged'
                            suspend
                            logger 'suspended:  unplugged'
                        fi
                        ;;
                    00000001)
                        logger 'AC pluged'
                        ;;
                esac
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    battery)
        case "$2" in
            BAT0)
                case "$4" in
                    00000000)
                        logger 'Battery online'
                        ;;
                    00000001)
                        logger 'Battery offline'
                        ;;
                esac
                ;;
            CPU0)
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    button/lid)
        case "$3" in
            close)
                logger 'LID closed'
                # $lock_cmd
                if [[ "$plugged_in" == 0 ]]; then
                    logger 'suspending: lid closed'
                    lock
                    suspend
                    logger 'suspended:  lid closed'
                else
                    logger 'locking:    lid closed'
                    lock
                    logger 'locked:     lid closed'
                fi
                ;;
            open)
                logger 'LID opened'
                ;;
            *)
                logger "ACPI action undefined: $3"
                ;;
    esac
    ;;
    *)
        logger "ACPI group/action undefined: $1 / $2"
        ;;
esac
