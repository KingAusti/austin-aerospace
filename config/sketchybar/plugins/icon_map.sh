#!/usr/bin/env bash
# ─────────────────────────────────────────────────
#  App → sketchybar-app-font icon map
#  Sets $icon_result to the correct font character.
#  Font must be installed: brew install FelixKratz/formulae/sketchybar-app-font
# ─────────────────────────────────────────────────

function icon_map() {
  # shellcheck disable=SC2034  # icon_result is read by callers after sourcing this file
  case "$1" in
    # ── Terminals ──────────────────────────────────
    "Ghostty"|"iTerm2"|"Terminal"|"Alacritty"|"kitty"|"WezTerm")
      icon_result=""   ;;  # nf-oct-terminal

    # ── Browsers ───────────────────────────────────
    "Dia"|"Safari"|"Orion")
      icon_result=""   ;;  # nf-fa-safari
    "Google Chrome"|"Chromium")
      icon_result=""   ;;  # nf-fa-chrome
    "Firefox"|"Firefox Developer Edition")
      icon_result=""   ;;  # nf-fa-firefox
    "Arc")
      icon_result=""   ;;  # arc-ish globe

    # ── Communication ──────────────────────────────
    "Slack")
      icon_result=""   ;;
    "Discord")
      icon_result="ﭮ"   ;;
    "Telegram")
      icon_result=""   ;;
    "Mail")
      icon_result=""   ;;

    # ── Code & Dev ─────────────────────────────────
    "Code"|"Visual Studio Code")
      icon_result=""   ;;
    "Xcode")
      icon_result=""   ;;
    "Cursor")
      icon_result=""   ;;
    "Neovide")
      icon_result=""   ;;
    "TablePlus")
      icon_result=""   ;;
    "Insomnia"|"Paw")
      icon_result=""   ;;

    # ── Productivity ───────────────────────────────
    "Finder")
      icon_result=""   ;;
    "Notes")
      icon_result=""   ;;
    "Obsidian")
      icon_result=""   ;;
    "Notion")
      icon_result=""   ;;
    "Calendar")
      icon_result=""   ;;
    "Reminders")
      icon_result=""   ;;
    "Activity Monitor")
      icon_result=""   ;;
    "System Preferences"|"System Settings")
      icon_result=""   ;;

    # ── Media ──────────────────────────────────────
    "Spotify")
      icon_result=""   ;;
    "Music")
      icon_result=""   ;;
    "Photos")
      icon_result=""   ;;
    "Figma")
      icon_result=""   ;;
    "Preview")
      icon_result=""   ;;

    # ── Utilities ──────────────────────────────────
    "1Password")
      icon_result=""   ;;
    "Alfred"|"Raycast")
      icon_result=""   ;;
    "Bartender")
      icon_result=""   ;;

    # ── Fallback ───────────────────────────────────
    *)
      icon_result=""   ;;
  esac
}
