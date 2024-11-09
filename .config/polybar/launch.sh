#!/bin/bash

#Must be at ~/.config/polybar/config/launch.sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload example &
done

# polybar --reload example &

echo "Polybar launched..."
