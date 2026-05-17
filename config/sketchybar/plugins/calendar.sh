#!/usr/bin/env bash
# ─────────────────────────────────────────────────
#  Calendar / Clock Plugin
# ─────────────────────────────────────────────────

# Format: Mon 16  11:42 AM
DATE="$(date '+%a %-d')"
TIME="$(date '+%I:%M %p')"

sketchybar --set "$NAME" label="$DATE  $TIME"
