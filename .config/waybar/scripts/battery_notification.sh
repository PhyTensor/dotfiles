
#!/bin/bash

battery_capacity=$(cat /sys/class/power_supply/BAT0/capacity)
battery_status=$(cat /sys/class/power_supply/BAT0/status)

# Function to send notifications
send_notification() {
    local message="$1"
    notify-send "Battery Status" "$message"
}

# Check battery status and capacity
if [ "$battery_status" = "Charging" ] && [ "$battery_capacity" -ge 90 ]; then
    # Notify for full battery
    if [ ! -f /tmp/full_battery_notified ] || [ $(($(date +%s) - $(stat -c %Y /tmp/full_battery_notified))) -ge 2 ]; then
        send_notification "  $battery_capacity% Unplug from AC."
        touch /tmp/full_battery_notified
    fi
elif [ "$battery_capacity" -le 21 ] && [ "$battery_status" != "Charging" ]; then
    # Notify for critical battery
    if [ ! -f /tmp/low_battery_notified ] || [ $(($(date +%s) - $(stat -c %Y /tmp/low_battery_notified))) -ge 2 ]; then
        send_notification "  21% Plug in AC."
        touch /tmp/low_battery_notified
    fi

    # Hibernate when battery is critical (below 5% for safety margin)
    if [ "$battery_capacity" -le 15 ]; then
        send_notification "  16% System Will Hibernate Now!!!"
        sleep 6 && systemctl hibernate
    fi
elif [ "$battery_capacity" -le 30 ] && [ "$battery_status" != "Charging" ]; then
    # Notify for warning battery level
    if [ ! -f /tmp/warning_battery_notified ] || [ $(($(date +%s) - $(stat -c %Y /tmp/warning_battery_notified))) -ge 2 ]; then
        send_notification "  30% Plug in AC soon."
        touch /tmp/warning_battery_notified
    fi
else
    # Reset notifications
    rm -f /tmp/full_battery_notified
    rm -f /tmp/low_battery_notified
    rm -f /tmp/warning_battery_notified
fi
