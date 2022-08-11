#!/usr/bin/env bash

# You can call this script like this:
# $ ./brightness.sh up
# $ ./brightness.sh down

function get_brightness {
  xbacklight -get | cut -d '.' -f 1
}

function send_notification {
  icon="~/.icons/dunst/sun.png"
  brightness=$(get_brightness)
  bar=$(seq -s "─" 0 $((brightness / 5)) | sed 's/[0-9]//g')
  # Send the notification
  dunstify -i "$icon" -r 5555 -u normal "    $bar"
}

case $1 in
  up)
    # increase the backlight by 5%
    xbacklight -inc 5
    send_notification
    ;;
  down)
    # decrease the backlight by 5%
    xbacklight -dec 5
    send_notification
    ;;
esac