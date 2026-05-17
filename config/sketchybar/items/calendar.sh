#!/usr/bin/env bash
# ─────────────────────────────────────────────────
#  Calendar / Clock — Right side
# ─────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"
PLUGIN_DIR="$CONFIG_DIR/plugins"

source "$CONFIG_DIR/colors.sh"

# nf-fa-calendar U+F073 → UTF-8: ef 81 b3
ICON=$(printf '\xef\x81\xb3')

sketchybar --add item calendar right \
  --set calendar                                       \
    icon="$ICON"                                       \
    icon.font="VictorMono Nerd Font Mono:Regular:18.0" \
    icon.color=$AQUA_COLOR                             \
    label.font="VictorMono Nerd Font Mono:SemiBold:14.0"                  \
    label.color=$FG_COLOR                              \
    background.color=$ITEM_BG_COLOR                    \
    background.corner_radius=7                         \
    background.height=28                               \
    update_freq=30                                     \
    script="$PLUGIN_DIR/calendar.sh"
