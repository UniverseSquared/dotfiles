#!/bin/sh

# kill polybar if it's already running
killall -q polybar

# wait until it dies
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# launch polybar on each monitor
for monitor in $(polybar -m | cut -d ':' -f 1); do
    MONITOR=$monitor polybar -r mybar &
done
