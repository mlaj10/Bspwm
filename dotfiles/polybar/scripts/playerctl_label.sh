#!/bin/sh
#
playerctl_label=$(playerctl metadata --all-players --format '{{ artist }} - {{ title }}' 2> /dev/null)

echo " $playerctl_label"
