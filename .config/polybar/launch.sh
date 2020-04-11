#!/bin/sh

# kill polybar if it's already running
killall -q polybar

# wait until it dies
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# launch polybar
polybar -r mybar &
