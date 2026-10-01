#!/bin/sh
ps -A -o %cpu= | awk -v n="$(sysctl -n hw.ncpu)" '{s+=$1} END {printf "%d%%", s/n}'
