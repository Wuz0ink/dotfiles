setxkbmap -layout se
xset r rate 240 40
xset m 1/1

start-pulseaudio-x11
dbus-run-session -- awesome
