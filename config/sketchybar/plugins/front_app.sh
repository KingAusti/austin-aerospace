#!/usr/bin/env bash
# ─────────────────────────────────────────────────
#  Front App Plugin
#  Fired by: front_app_switched
#  Env vars: $INFO = focused application name
# ─────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/plugins/icon_map.sh"

APP_NAME="${INFO:-Finder}"

sketchybar --set "$NAME" label="$APP_NAME"
