#!/bin/bash

# Check for updates
if pacman -Qu | wc -l > /dev/null; then
    # If updates are available, notify the user
    notify-send "Updates Available" "There are updates available for your system. Please update your system to ensure optimal performance and security." -u critical --icon=dialog-information
    # Open kitty terminal and run command to update system - sudo pacman -Syu
    kitty sudo pacman -Syu
else
    # If no updates are available, notify the user
    notify-send "No Updates Available" "Your system is up to date. Enjoy your system!" -u normal --icon=dialog-information
fi

