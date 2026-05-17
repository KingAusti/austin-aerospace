#!/usr/bin/env bash
# ─────────────────────────────────────────────────
#  CPU Usage — Right side
# ─────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"
PLUGIN_DIR="$CONFIG_DIR/plugins"

source "$CONFIG_DIR/colors.sh"

# nf-fa-microchip U+F2DB → UTF-8: ef 8b 9b
ICON=$(printf '\xef\x8b\x9b')

sketchybar --add item cpu right \
  --set cpu                                             \
    icon="$ICON"                                        \
    icon.font="VictorMono Nerd Font Mono:Regular:18.0"  \
    icon.color=$YELLOW_COLOR                            \
    label.font="VictorMono Nerd Font Mono:SemiBold:14.0"                   \
    label.color=$FG_COLOR                               \
    background.color=$ITEM_BG_COLOR                     \
    background.corner_radius=7                          \
    background.height=28                                \
    update_freq=5                                       \
    script="$PLUGIN_DIR/cpu.sh"
