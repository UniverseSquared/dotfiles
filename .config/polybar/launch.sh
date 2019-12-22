#!/bin/sh

# kill polybar if it's already running
killall -q polybar

# wait until it dies
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# launch polybar
polybar -r mybar &

# lower polybar below other windows
sleep 1
xdo lower -p $(pidof polybar)
