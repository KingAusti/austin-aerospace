#!/usr/bin/env bash
# ─────────────────────────────────────────────────
#  CPU Usage Plugin
# ─────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"

# Sum all process CPU percentages; cap at 100 for display sanity
CPU_PCT=$(ps -A -o %cpu | awk '{s+=$1} END {pct=int(s); if(pct>100) pct=100; print pct}')

if [ "$CPU_PCT" -ge 80 ]; then
  COLOR=$RED_COLOR
elif [ "$CPU_PCT" -ge 50 ]; then
  COLOR=$ORANGE_COLOR
elif [ "$CPU_PCT" -ge 30 ]; then
  COLOR=$YELLOW_COLOR
else
  COLOR=$FG_COLOR
fi

sketchybar --set "$NAME" \
  icon.color=$COLOR     \
  label="${CPU_PCT}%"
