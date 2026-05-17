#!/usr/bin/env bash
# ─────────────────────────────────────────────────
#  Battery — Right side
# ─────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"
PLUGIN_DIR="$CONFIG_DIR/plugins"

source "$CONFIG_DIR/colors.sh"

sketchybar --add item battery right \
  --set battery                                         \
    icon.font="VictorMono Nerd Font Mono:Regular:18.0" \
    icon.color=$ACCENT_COLOR                           \
    label.font="VictorMono Nerd Font Mono:SemiBold:14.0"                  \
    label.color=$FG_COLOR                              \
    background.color=$ITEM_BG_COLOR                    \
    background.corner_radius=7                         \
    background.height=28                               \
    update_freq=120                                    \
    script="$PLUGIN_DIR/battery.sh"                    \
  --subscribe battery power_source_change system_will_sleep
