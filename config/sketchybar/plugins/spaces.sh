#!/usr/bin/env bash
# ─────────────────────────────────────────────────
#  Spaces Plugin — highlights active AeroSpace workspace
#  Fired by: aerospace_workspace_change trigger
#  Env vars: $NAME (e.g. "space.3"), $FOCUSED_WORKSPACE (e.g. "3")
# ─────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"

# --update fires this script with no FOCUSED_WORKSPACE; skip to avoid
# clobbering the state set by the real aerospace_workspace_change trigger.
[ -z "$FOCUSED_WORKSPACE" ] && exit 0

# Extract the workspace number from the item name ("space.N" → "N")
WS="${NAME#space.}"

if [ "$WS" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    icon.color=$BG_DARK   \
    background.color=$ACCENT_COLOR
else
  sketchybar --set "$NAME" \
    icon.color=$GRAY_COLOR \
    background.color=$ITEM_BG_COLOR
fi
