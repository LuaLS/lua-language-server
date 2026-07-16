#!/bin/bash
# Wrapper script for Zig compiler to filter out -lstdc++fs
# Zig's libc++ already includes filesystem support

# Filter out -lstdc++fs from arguments
args=()
for arg in "$@"; do
    if [ "$arg" != "-lstdc++fs" ]; then
        args+=("$arg")
    fi
done

# Call zig c++ with filtered arguments
exec zig c++ "${args[@]}"
