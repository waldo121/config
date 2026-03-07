#!/usr/bin/env sh
set -e
mkdir -p ~/Videos/recordings
OUTPUT=$(slurp -o -f %o)
if [ -n "$OUTPUT" ]; then
    gpu-screen-recorder -w "$OUTPUT" -o ~/Videos/recordings/$(date +%Y%m%d_%H%M%S).mp4
fi