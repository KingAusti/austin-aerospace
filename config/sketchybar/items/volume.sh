#!/usr/bin/env bash
# ─────────────────────────────────────────────────
#  Volume — Right side
# ─────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"
PLUGIN_DIR="$CONFIG_DIR/plugins"

source "$CONFIG_DIR/colors.sh"

sketchybar --add item volume right \
  --set volume                                          \
    icon.font="VictorMono Nerd Font Mono:Regular:18.0" \
    icon.color=$BLUE_COLOR                             \
    label.font="VictorMono Nerd Font Mono:SemiBold:14.0"                  \
    label.color=$FG_COLOR                              \
    background.color=$ITEM_BG_COLOR                    \
    background.corner_radius=7                         \
    background.height=28                               \
    update_freq=0                                      \
    script="$PLUGIN_DIR/volume.sh"                     \
  --subscribe volume volume_change
