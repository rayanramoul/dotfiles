#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"

# CPU usage: 'top -l 1' second sample is more accurate but slower; use first sample.
CPU=$(top -l 1 -n 0 -s 0 | awk '/CPU usage/ {gsub("%",""); print int($3 + $5)}')

# Memory pressure: pages free / pages total — easier proxy = `memory_pressure`.
MEM_PCT=$(memory_pressure 2>/dev/null \
          | awk '/System-wide memory free percentage/ {print 100 - $5}')
[ -z "$MEM_PCT" ] && MEM_PCT="?"

# CPU temp via osx-cpu-temp if installed; the tool returns 0.0 on Apple Silicon
# (no SMC sensor key), so hide the temp suffix when we can't read it.
TEMP=""
if command -v osx-cpu-temp >/dev/null 2>&1; then
  T=$(osx-cpu-temp 2>/dev/null | awk '{print int($1)}')
  [ -n "$T" ] && [ "$T" -gt 0 ] && TEMP="  ${T}°"
fi

# Color the CPU figure by load
if [ "$CPU" -ge 75 ] 2>/dev/null; then
  CPU_COLOR="$ERROR"
elif [ "$CPU" -ge 40 ] 2>/dev/null; then
  CPU_COLOR="$WARN"
else
  CPU_COLOR="$SUCCESS"
fi

sketchybar --set "$NAME" \
  icon="󰘚" \
  icon.color="$CPU_COLOR" \
  label="${CPU}%  ${MEM_PCT}%${TEMP}"
