#!/usr/bin/env bash
# ─────────────────────────────────────────────────
#  AeroSpace Workspace Indicators
# ─────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"
PLUGIN_DIR="$CONFIG_DIR/plugins"

source "$CONFIG_DIR/colors.sh"

# Create one item per workspace (1–9)
for i in $(seq 1 9); do
  sketchybar --add item "space.$i" left \
    --set "space.$i"                             \
      icon="$i"                                  \
      icon.font="VictorMono Nerd Font Mono:Bold:13.0"         \
      icon.color=$GRAY_COLOR                     \
      label.drawing=off                          \
      background.color=$ITEM_BG_COLOR            \
      background.corner_radius=6                 \
      background.height=24                       \
      background.drawing=on                      \
      width=26                                   \
      align=center                               \
      padding_left=3                             \
      padding_right=3                            \
      script="$PLUGIN_DIR/spaces.sh"             \
    --subscribe "space.$i" aerospace_workspace_change
done

# Separator bracket for visual grouping
# shellcheck disable=SC2046
sketchybar --add bracket spaces_bracket \
  $(for i in $(seq 1 9); do echo "space.$i"; done) \
  --set spaces_bracket \
    background.color=$ITEM_BG_COLOR \
    background.corner_radius=7      \
    background.height=28            \
    background.drawing=on
