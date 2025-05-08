#!/usr/bin/env bash


files=($HOME/.config/awesome/wallpaper/*)
wallpaper=${files[$RANDOM % ${#files[@]}]}

/home/antonalf/.pyenv/shims/wal -i $wallpaper &

feh --bg-fill "$wallpaper"
