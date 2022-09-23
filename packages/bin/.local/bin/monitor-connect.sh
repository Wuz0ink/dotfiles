#!/bin/bash
logger Running monitor script

# wait for device to be ready
sleep 1s

# setup display
export DISPLAY=:0
export XAUTHORITY=/home/linde/.Xauthority

# connect displays
xrandr --auto

# try to 144hz
active_monitors=$(xrandr | grep -E '(.*) connected' | sed 's/^\(.*\) connected.*/\1/')
for monitor in $active_monitors
do
  logger "Configuring $monitor"
  xrandr --output "$monitor" --mode 1920x1080 --rate 144
done

# mouse & keyboard settings
setxkbmap -layout us
xset r rate 240 40
xset m 1/1
