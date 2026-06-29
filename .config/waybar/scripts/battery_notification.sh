#!/bin/bash
#
# Battery notification script for Waybar.
#
# Waybar runs this script every N seconds (configured via "interval" in config.jsonc).
# It reads the current battery state and sends desktop notifications at key thresholds.
# The script produces no stdout — it exists purely for notification side-effects.
#

# --- Configuration ---
# How long (in seconds) to wait before sending the same notification again.
# Prevents notification spam since Waybar polls this script repeatedly.
NOTIFY_COOLDOWN=17 # in seconds

# Battery percentage at or above which (while charging) the user is reminded
# to unplug. Keeping lithium-ion batteries below ~80-85% extends their lifespan.
FULL_THRESHOLD=84

# Battery percentage at or below which (while discharging) the user gets a
# gentle "plug in soon" reminder. Not urgent.
WARNING_THRESHOLD=30

# Battery percentage at or below which (while discharging) the user gets an
# urgent "plug in now" notification.
LOW_THRESHOLD=21

# Battery percentage at or below which (while discharging) the system will
# hibernate after a countdown to prevent data loss from a dead battery.
CRITICAL_THRESHOLD=15

# How many seconds to wait before hibernating after the critical notification.
# During this window, plugging in the charger will cancel the hibernate.
HIBERNATE_COUNTDOWN=60

# --- Lock file directory ---
# Lock files track which notifications have been sent, so we don't repeat them
# within the cooldown window. Stored in XDG_RUNTIME_DIR (a per-user tmpfs),
# falling back to /tmp if unavailable.
LOCK_DIR="${XDG_RUNTIME_DIR:-/tmp}/waybar_battery"
mkdir -p "$LOCK_DIR"

# --- Read battery state ---
# Uses BAT* glob instead of hardcoded BAT0 for compatibility across different
# hardware. `head -1` handles the rare case of multiple batteries.
battery_capacity=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
battery_status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)

# Exit silently if no battery is found (e.g. on a desktop PC).
if [[ -z "$battery_capacity" || -z "$battery_status" ]]; then
    exit 0
fi

# --- Helper: send a desktop notification ---
# $1 = message text
# $2 = urgency level (default: "critical")
send_notification() {
    local urgency="${2:-critical}"
    notify-send --urgency="$urgency" --expire-time=10000 "Battery Status" "$1"
}

# --- Helper: check if enough time has passed to notify again ---
# Compares the lock file's modification time against NOTIFY_COOLDOWN.
# Returns true (0) if we should send a notification, false (1) if too soon.
# $1 = path to the lock file
should_notify() {
    local file="$1"
    [[ ! -f "$file" || $(($(date +%s) - $(stat -c %Y "$file"))) -ge "$NOTIFY_COOLDOWN" ]]
}

# --- Helper: remove lock files that no longer apply ---
# When the battery state changes (e.g. from "warning" to "critical"), this
# clears lock files from the previous state so those notifications can fire
# fresh if the state is re-entered later.
# $1 = name of the lock file to KEEP (the currently active state)
cleanup_locks() {
    local keep="$1"
    for f in "$LOCK_DIR"/*_notified; do
        [[ "$(basename "$f")" == "$keep" ]] && continue
        rm -f "$f"
    done
}

# --- Main logic ---
# Conditions are checked most-critical-first using elif, so only one branch
# runs per invocation. For example, at 14% battery (which is ≤15, ≤21, AND ≤30),
# only the critical branch executes.

if [[ "$battery_status" == "Charging" ]] && (( battery_capacity >= FULL_THRESHOLD )); then
    # CHARGING + FULL: remind user to unplug to preserve battery health
    if should_notify "$LOCK_DIR/full_notified"; then
        send_notification "${battery_capacity}% — Unplug from AC" "normal"
        touch "$LOCK_DIR/full_notified"
    fi
    cleanup_locks "full_notified"

elif [[ "$battery_status" != "Charging" ]] && (( battery_capacity <= CRITICAL_THRESHOLD )); then
    # DISCHARGING + CRITICAL: warn user, then hibernate after countdown
    if should_notify "$LOCK_DIR/critical_notified"; then
        send_notification "${battery_capacity}% — System will hibernate in ${HIBERNATE_COUNTDOWN}s"
        touch "$LOCK_DIR/critical_notified"

        # Background the hibernate countdown so this script returns immediately
        # to Waybar (otherwise it would block the bar for 60+ seconds).
        (
            sleep "$HIBERNATE_COUNTDOWN"

            # Re-check battery state after the countdown — if the user plugged
            # in the charger during this window, cancel the hibernate.
            cur_cap=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
            cur_status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)
            if [[ "$cur_status" != "Charging" ]] && (( cur_cap <= CRITICAL_THRESHOLD )); then
                notify-send --urgency=critical --expire-time=5000 "Battery Status" "Hibernating now"
                sleep 3
                systemctl hibernate
            fi
        ) &
        disown # Detach the background process from the shell
    fi
    cleanup_locks "critical_notified"

elif [[ "$battery_status" != "Charging" ]] && (( battery_capacity <= LOW_THRESHOLD )); then
    # DISCHARGING + LOW: urgent reminder to plug in
    if should_notify "$LOCK_DIR/low_notified"; then
        send_notification "${battery_capacity}% — Plug in AC"
        touch "$LOCK_DIR/low_notified"
    fi
    cleanup_locks "low_notified"

elif [[ "$battery_status" != "Charging" ]] && (( battery_capacity <= WARNING_THRESHOLD )); then
    # DISCHARGING + WARNING: gentle heads-up, not urgent yet
    if should_notify "$LOCK_DIR/warning_notified"; then
        send_notification "${battery_capacity}% — Plug in AC soon" "normal"
        touch "$LOCK_DIR/warning_notified"
    fi
    cleanup_locks "warning_notified"

else
    # NORMAL STATE: battery is in a healthy range, clear all lock files
    # so notifications can fire fresh when a threshold is hit again.
    rm -f "$LOCK_DIR"/*_notified
fi
