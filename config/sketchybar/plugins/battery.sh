#!/usr/bin/env bash
# ─────────────────────────────────────────────────
#  Battery Plugin
#  Fired by: power_source_change, system_will_sleep, update_freq
# ─────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"

# Nerd Font icons via printf hex escapes (encoding-safe)
# nf-fa-battery-full  U+F240 → ef 89 80
# nf-fa-battery-3     U+F241 → ef 89 81
# nf-fa-battery-2     U+F242 → ef 89 82
# nf-fa-battery-1     U+F243 → ef 89 83
# nf-fa-battery-0     U+F244 → ef 89 84
# nf-fa-bolt          U+F0E7 → ef 83 a7  (charging)
# nf-fa-plug          U+F1E6 → ef 87 a6  (fully charged on AC)
NF_FULL=$(     printf '\xef\x89\x80')
NF_THREE=$(    printf '\xef\x89\x81')
NF_TWO=$(      printf '\xef\x89\x82')
NF_ONE=$(      printf '\xef\x89\x83')
NF_EMPTY=$(    printf '\xef\x89\x84')
NF_BOLT=$(     printf '\xef\x83\xa7')
NF_PLUG=$(     printf '\xef\x87\xa6')

BATT_INFO="$(pmset -g batt)"
PERCENTAGE=$(echo "$BATT_INFO" | grep -Eo "\d+%" | cut -d% -f1 | head -1)
CHARGING=$(echo "$BATT_INFO" | grep -c 'AC Power')
PCT="${PERCENTAGE:-0}"

if [ "$CHARGING" -gt 0 ]; then
  if [ "$PCT" -eq 100 ]; then
    ICON=$NF_PLUG
    COLOR=$ACCENT_COLOR
  else
    ICON=$NF_BOLT
    COLOR=$PURPLE_COLOR
  fi
elif [ "$PCT" -le 10 ]; then
  ICON=$NF_EMPTY
  COLOR=$RED_COLOR
elif [ "$PCT" -le 25 ]; then
  ICON=$NF_ONE
  COLOR=$ORANGE_COLOR
elif [ "$PCT" -le 50 ]; then
  ICON=$NF_TWO
  COLOR=$YELLOW_COLOR
elif [ "$PCT" -le 75 ]; then
  ICON=$NF_THREE
  COLOR=$FG_COLOR
else
  ICON=$NF_FULL
  COLOR=$ACCENT_COLOR
fi

sketchybar --set "$NAME" \
  icon="$ICON"           \
  icon.color=$COLOR      \
  label="${PCT}%"
