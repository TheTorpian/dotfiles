#!/usr/bin/env bash

# You can call this script like this:
# $ ./volume.sh up
# $ ./volume.sh down
# $ ./volume.sh mute

function get_volume {
  amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
  amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
  iconSound="~/.config/dunst/icons/audio_medium.svg"
  iconMuted="~/.config/dunst/icons/audio_mute.svg"
  if is_mute ; then
    dunstify -i $iconMuted -r 2593 -u low "mute"
  else
    volume=$(get_volume)
    bar=$(seq --separator="─" 0 "$((volume / 5))" | sed 's/[0-9]//g')
    # Send the notification
    dunstify -i $iconSound -r 2593 -u low "$bar"
  fi
}

case $1 in
  up)
    # set the volume on (if it was muted)
    amixer -D pulse set Master on > /dev/null
    # up the volume (+ 5%)
    amixer -D pulse sset Master 5%+ > /dev/null
    send_notification
    ;;
  down)
    amixer -D pulse set Master on > /dev/null
    amixer -D pulse sset Master 5%- > /dev/null
    send_notification
    ;;
  mute)
    # toggle mute
    amixer -D pulse set Master 1+ toggle > /dev/null
    send_notification
    ;;
esac
