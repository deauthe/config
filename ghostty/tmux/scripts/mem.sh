#!/bin/sh
memory_pressure -Q 2>/dev/null | awk -F': ' '/percentage/ {gsub("%","",$2); printf "%d%%", 100-$2}'
