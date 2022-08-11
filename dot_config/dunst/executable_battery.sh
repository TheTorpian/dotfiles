#! /bin/bash

# A simple battery-level script for i3bar
# If there is no battery (i.e. desktop) nothing is output
# This script assumes at least one battery in your laptop will be BAT1

if [ -d "/sys/class/power_supply/BAT1" ]; then
    echo `acpi -b | awk '!/Unknown/{print $2$4}' | tr -d ,` && echo "blank"
    [[ $(acpi -b | awk '!/Unknown/{print $3}') == "Discharging," ]] && echo "#ff0000" || echo "#33cc33"
    # Alert if the total of all battery capacities is less than the set lower limit
    [[ $(echo "$(cat /sys/class/power_supply/BAT*/capacity | sed 's/$/+/' | tr -d '\n' | sed 's/.$//')" | bc) -le 11 ]] && notify-send -u critical 'Battery below 10%!'
else
    echo
fi
