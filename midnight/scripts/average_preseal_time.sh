#!/bin/bash
#set -x
# extract timestamps from the log file
timestamps=($(docker logs midnight 2>/dev/stdout | grep -i "pre-seal" | awk '{print $1, $2}'))

# check if at least two timestamps exist
if [ ${#timestamps[@]} -lt 2 ]; then
    echo "not enough timestamps to calculate average time."
    exit 1
fi

total_diff=0
count=0

# iterate over timestamps and calculate time differences
for ((i=1; i<${#timestamps[@]}; i++)); do
    t1=$(date -d "${timestamps[$((i-1))]}" +%s)
    t2=$(date -d "${timestamps[$i]}" +%s)
    diff=$((t2 - t1))
    total_diff=$((total_diff + diff))
    count=$((count + 1))
done

# calculate average time in seconds
average_time=$((total_diff / count))

# convert seconds to minutes and seconds
average_minutes=$((average_time / 60))
average_seconds=$((average_time % 60))

echo "average time between pre-sealed blocks: ${average_minutes} minutes and ${average_seconds} seconds"
