#!/bin/bash

battery_capacity=$(< /sys/class/power_supply/BAT0/capacity)
battery_status=$(< /sys/class/power_supply/BAT0/status)

# Define icon paths
icon_charging="/usr/share/icons/Papirus/48x48/status/battery-charging.svg"
icon_low="/usr/share/icons/Papirus/48x48/status/battery-low.svg"
icon_critical="/usr/share/icons/Papirus/48x48/status/battery-caution.svg"
icon_full="/usr/share/icons/Papirus/48x48/status/battery.svg"

# Function to send notifications
send_notification() {
    local message="$1"
    local icon="$2"
    # send notification with a critical urgency level
    # notify-send --icon=dialog-warning "🔋 Battery Status" "$message" --urgency=critical --expire-time=10000
    notify-send --icon="$icon" --urgency=critical --expire-time=10000 "🔋 Battery Status" "$message"
}

# Notification throttling function
should_notify() {
    local file="$1"
    local threshold="$2"
    [[ ! -f "$file" || $(($(date +%s) - $(stat -c %Y "$file"))) -ge "$threshold" ]]
}

# Check battery status and capacity
if [ "$battery_status" = "Charging" ] && [ "$battery_capacity" -ge 90 ]; then
    # Notify for full battery
    if should_notify /tmp/full_battery_notified 2; then
        send_notification "$battery_capacity% - Unplug from AC" "$icon_full"
        touch /tmp/full_battery_notified
    fi
elif [ "$battery_status" != "Charging" ] && [ "$battery_capacity" -le 15 ]; then
    # Hibernate when battery is critical (below 5% for safety margin)
    # if [ "$battery_capacity" -le 15 ] && [ "$battery_status" != "Charging" ]; then
    if should_notify /tmp/critical_battery_notified 2; then
        send_notification "$battery_capacity% - System will hibernate in 60 seconds" "$icon_critical"
        touch /tmp/critical_battery_notified
        sleep 60 && systemctl hibernate
    fi
elif [ "$battery_status" != "Charging" ] && [ "$battery_capacity" -le 21 ]; then
    # Notify for critical battery
    if should_notify /tmp/low_battery_notified 2; then
        send_notification "$battery_capacity% - Plug in AC." "$icon_low"
        touch /tmp/low_battery_notified
    fi
elif [ "$battery_status" != "Charging" ] && [ "$battery_capacity" -le 30 ]; then
    # Notify for warning battery level
    if should_notify /tmp/warning_battery_notified 2; then
        send_notification "$battery_capacity% - Plug in AC soon" "$icon_low"
        touch /tmp/warning_battery_notified
    fi
else
    # Reset notifications
    rm -f /tmp/full_battery_notified
    rm -f /tmp/low_battery_notified
    rm -f /tmp/warning_battery_notified
    rm -f /tmp/critical_battery_notified
fi
