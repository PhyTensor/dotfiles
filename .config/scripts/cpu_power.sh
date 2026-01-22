#!/bin/bash

# Path to Intel RAPL energy counter
ENERGY_FILE="/sys/class/powercap/intel-rapl:0/energy_uj"
INTERVAL=1  # seconds

# Check if file exists
if [ ! -f "$ENERGY_FILE" ]; then
    echo "RAPL energy file not found. Your CPU may not support RAPL."
    exit 1
fi

# Read initial energy
prev=$(cat "$ENERGY_FILE")

while true; do
    sleep $INTERVAL
    curr=$(cat "$ENERGY_FILE")

    # Calculate delta energy in joules
    delta_joule=$((curr - prev))
    prev=$curr

    # Power in watts: delta energy (J) / interval (s)
    # energy_uj is in microjoules, so divide by 1e6
    power=$(echo "scale=2; $delta_joule/1000000/$INTERVAL" | bc)

    # Print to terminal
    echo "CPU Power: ${power} W"
done

