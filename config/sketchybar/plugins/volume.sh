#!/usr/bin/env bash
# ─────────────────────────────────────────────────
#  Volume Plugin
#  Fired by: volume_change
# ─────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"

# Nerd Font icons via printf hex escapes (encoding-safe)
# U+F6A9 (nf-fa-volume-mute) is absent from VictorMono Nerd Font Mono — use F026 (silent
# speaker) for muted; it visually reads as "no sound" without a slash glyph.
# nf-fa-volume-off  U+F026 → ef 80 a6
# nf-fa-volume-down U+F027 → ef 80 a7
# nf-fa-volume-up   U+F028 → ef 80 a8
NF_OFF=$(printf  '\xef\x80\xa6')
NF_LOW=$(printf  '\xef\x80\xa7')
NF_HIGH=$(printf '\xef\x80\xa8')

VOLUME=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null || echo 0)
MUTED=$(osascript  -e 'output muted of (get volume settings)'  2>/dev/null || echo false)

if [ "$MUTED" = "true" ]; then
  ICON=$NF_OFF          # silent speaker = muted
  COLOR=$GRAY_COLOR
  LABEL="mute"
elif [ "$VOLUME" -eq 0 ]; then
  ICON=$NF_OFF
  COLOR=$GRAY_COLOR
  LABEL="0%"
elif [ "$VOLUME" -lt 50 ]; then
  ICON=$NF_LOW
  COLOR=$BLUE_COLOR
  LABEL="${VOLUME}%"
else
  ICON=$NF_HIGH
  COLOR=$BLUE_COLOR
  LABEL="${VOLUME}%"
fi

sketchybar --set "$NAME" \
  icon="$ICON"           \
  icon.color=$COLOR      \
  label="$LABEL"
