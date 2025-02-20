#!/bin/bash
while true; do
    # Get time and date
    TIME=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Get CPU usage (subtract idle from 100%)
    CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1 "%"}')
    
    # Get memory usage (used / total)
    MEM=$(free -h | grep Mem | awk '{print $3 "/" $2}')
    
    # Get volume level
    VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')
    
    # Output the status in the desired format
    echo "MEM: $MEM | CPU: $CPU | TIME: $TIME | VOL: $VOL"
    
    # Sleep for 1 second before updating
    sleep 1
done

