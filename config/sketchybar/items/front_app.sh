#!/usr/bin/env bash
# ─────────────────────────────────────────────────
#  Front App — Left pill, accent background
# ─────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"
PLUGIN_DIR="$CONFIG_DIR/plugins"

source "$CONFIG_DIR/colors.sh"

sketchybar --add item front_app left \
  --set front_app                                      \
    icon.drawing=off                                  \
    label.font="VictorMono Nerd Font Mono:SemiBold:14.0"                 \
    label.color=$BG_DARK                              \
    label.padding_left=10                             \
    label.padding_right=10                            \
    label.align=center                                \
    background.color=$FOREST_COLOR                    \
    background.corner_radius=8                        \
    background.height=30                              \
    padding_left=12                                   \
    padding_right=6                                   \
    update_freq=0                                     \
    script="$PLUGIN_DIR/front_app.sh"                 \
  --subscribe front_app front_app_switched
