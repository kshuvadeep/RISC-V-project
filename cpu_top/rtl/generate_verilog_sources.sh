#!/bin/bash

#!/bin/bash

# Set the RTL_PATH (you can also pass this as an argument)
RTL_PATH="/home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl"

# Find all .v, .sv, and .vh files and generate a Makefile-style list
find "$RTL_PATH" -maxdepth 1 -type f \( -name "*.v" -o -name "*.sv" -o -name "*.vh" \) | sort | awk -v prefix='$(RTL_PATH)/' '
{
    # Strip full path and prepend with $(RTL_PATH)/
    file = $0
    sub(/^.*\//, "", file)
    printf("  %s%s \\\n", prefix, file)
}
'

