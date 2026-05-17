#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
#  Deep Forest Gruvbox — macOS Desktop Rice Install Script
#
#  Installs: AeroSpace · SketchyBar · JankyBorders · Ghostty
#            Übersicht · VictorMono NF · sketchybar-app-font
#  Symlinks all configs and deploys Übersicht widget.
# ═══════════════════════════════════════════════════════════════════

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$HOME/.config-backup-$TIMESTAMP"

# ── Logging helpers ─────────────────────────────────────────────────
log()  { printf '\033[0;32m  ==>\033[0m %s\n' "$*"; }
step() { printf '\n\033[1;33m──── %s\033[0m\n' "$*"; }
warn() { printf '\033[0;33m  !!>\033[0m %s\n' "$*"; }
ok()   { printf '\033[0;32m  ✓  \033[0m %s\n' "$*"; }
die()  { printf '\033[0;31m  ✗  ERROR: %s\033[0m\n' "$*" >&2; exit 1; }

# ── Symlink helper (backs up existing non-links) ────────────────────
link() {
  local src="$1"
  local dst="$2"

  [ -e "$src" ] || die "Source does not exist: $src"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/$(basename "$dst")"
    warn "Backed up: $dst  →  $BACKUP_DIR/$(basename "$dst")"
  elif [ -L "$dst" ]; then
    rm "$dst"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  ok "Linked: $(basename "$dst")"
}

# ══════════════════════════════════════════════════════════════════════
step "1 / 6  Homebrew"
# ══════════════════════════════════════════════════════════════════════

if ! command -v brew &>/dev/null; then
  log "Homebrew not found — installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for Apple Silicon
  if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  log "Homebrew found, updating..."
  brew update --quiet
fi

# ══════════════════════════════════════════════════════════════════════
step "2 / 6  Taps"
# ══════════════════════════════════════════════════════════════════════

TAPS=(
  "FelixKratz/formulae"   # sketchybar, borders, sketchybar-app-font
  "nikitabobko/tap"        # aerospace
)

for t in "${TAPS[@]}"; do
  if brew tap | grep -q "^${t}$"; then
    ok "Already tapped: $t"
  else
    log "Tapping $t..."
    brew tap "$t"
    ok "$t"
  fi
done

# ══════════════════════════════════════════════════════════════════════
step "3 / 6  Formulae & Casks"
# ══════════════════════════════════════════════════════════════════════

install_pkg() {
  local pkg="$1"
  local flags="${2:-}"
  if brew list "$pkg" &>/dev/null; then
    ok "Already installed: $pkg"
  else
    log "Installing $pkg..."
    # shellcheck disable=SC2086
    brew install $flags "$pkg"
    ok "$pkg"
  fi
}

# Formulae
install_pkg "nikitabobko/tap/aerospace"
install_pkg "FelixKratz/formulae/sketchybar"
install_pkg "FelixKratz/formulae/borders"

# Casks
install_pkg "ghostty"                    "--cask"
install_pkg "ubersicht"                  "--cask"
install_pkg "font-victor-mono-nerd-font" "--cask"

# sketchybar-app-font is not a Homebrew formula — fetch from GitHub releases
install_sketchybar_app_font() {
  local dest="$HOME/Library/Fonts/sketchybar-app-font.ttf"
  if [ -f "$dest" ]; then
    ok "sketchybar-app-font already installed"
    return
  fi
  log "Fetching sketchybar-app-font from GitHub releases..."
  local url
  url=$(curl -fsSL "https://api.github.com/repos/kvndrsslr/sketchybar-app-font/releases/latest" \
    | grep "browser_download_url" | grep "\.ttf" | cut -d'"' -f4 | head -1)
  if [ -n "$url" ]; then
    curl -fsSL "$url" -o "$dest" && ok "sketchybar-app-font → ~/Library/Fonts/" \
      || warn "Download failed — install manually: github.com/kvndrsslr/sketchybar-app-font/releases"
  else
    warn "Could not resolve download URL — install manually: github.com/kvndrsslr/sketchybar-app-font/releases"
  fi
}
install_sketchybar_app_font

# ══════════════════════════════════════════════════════════════════════
step "4 / 7  Symlink Configs"
# ══════════════════════════════════════════════════════════════════════

link "$DOTFILES/config/ghostty"    "$CONFIG/ghostty"
link "$DOTFILES/config/aerospace"  "$CONFIG/aerospace"
link "$DOTFILES/config/sketchybar" "$CONFIG/sketchybar"
link "$DOTFILES/config/borders"    "$CONFIG/borders"

# ══════════════════════════════════════════════════════════════════════
step "5 / 7  Workspace Assignments"
# ══════════════════════════════════════════════════════════════════════

# Detect open apps and write [[on-window-detected]] rules into aerospace.toml.
# Finder always floats; system/utility processes are skipped.
AERO_CONFIG="$DOTFILES/config/aerospace/aerospace.toml"
SKIP_APPS=("Activity Monitor" "TextEdit" "System Preferences" "System Settings" "AeroSpace" "SketchyBar" "loginwindow" "Dock" "NotificationCenter")

# Strip any existing assignment section so we regenerate it cleanly
sed -i '' '/^# ── App → Workspace Assignments/,$d' "$AERO_CONFIG"

RAW_APPS=$(osascript -e 'tell application "System Events" to get name of every process whose background only is false' 2>/dev/null || true)

{
  printf '\n# ── App → Workspace Assignments ──────────────────\n'

  printf '\n[[on-window-detected]]\n'
  printf "if.app-name-regex-substring = 'Finder'\n"
  printf "run = 'layout floating'\n"

  SPACE=1
  IFS=', ' read -ra DETECTED <<< "$RAW_APPS"
  for APP in "${DETECTED[@]}"; do
    [[ "$APP" == "Finder" ]] && continue
    SKIP=false
    for S in "${SKIP_APPS[@]}"; do [[ "$APP" == "$S" ]] && SKIP=true && break; done
    $SKIP && continue

    printf '\n[[on-window-detected]]\n'
    printf "if.app-name-regex-substring = '%s'\n" "$APP"
    printf "run = 'move-node-to-workspace %d'\n" "$SPACE"
    ok "Assigned $APP → space $SPACE"
    (( SPACE++ ))
  done
} >> "$AERO_CONFIG"

# ══════════════════════════════════════════════════════════════════════
step "6 / 7  Übersicht Widget"
# ══════════════════════════════════════════════════════════════════════

UBER_DIR="$HOME/Library/Application Support/Übersicht/widgets"
mkdir -p "$UBER_DIR"

WIDGET_DST="$UBER_DIR/flip-clock.jsx"
if [ -f "$WIDGET_DST" ]; then
  warn "flip-clock.jsx already exists — overwriting"
fi
cp "$DOTFILES/ubersicht/flip-clock.jsx" "$WIDGET_DST"
ok "Flip-clock widget → $WIDGET_DST"

# ══════════════════════════════════════════════════════════════════════
step "7 / 7  Permissions & Services"
# ══════════════════════════════════════════════════════════════════════

# Mark all plugin and item scripts executable.
# Use the source directory — chmod through a symlink is unreliable on macOS.
find "$DOTFILES/config/sketchybar" -name "*.sh" -exec chmod +x {} \;
chmod +x "$DOTFILES/config/sketchybar/sketchybarrc"
chmod +x "$DOTFILES/config/borders/bordersrc"
ok "Script permissions set"

# Start SketchyBar as a brew service
log "Starting SketchyBar..."
brew services restart sketchybar && ok "SketchyBar started" \
  || warn "Could not start SketchyBar — run: brew services start sketchybar"

# Start JankyBorders
log "Starting JankyBorders..."
pkill borders 2>/dev/null || true
"$CONFIG/borders/bordersrc" &
ok "JankyBorders launched"

# AeroSpace — configured to start at login, just open it once
log "Opening AeroSpace..."
open -a AeroSpace 2>/dev/null && ok "AeroSpace opened" \
  || warn "AeroSpace not found in /Applications — open it manually after install"

# Reload Übersicht if already running
if pgrep -x "Übersicht" &>/dev/null; then
  open -g -a Übersicht
  ok "Übersicht refreshed"
else
  warn "Übersicht not running — open it from /Applications"
fi

# ══════════════════════════════════════════════════════════════════════
cat <<'DONE'

╔═════════════════════════════════════════════════════════════════════╗
║       Deep Forest Gruvbox — Installation Complete  🌿              ║
╠═════════════════════════════════════════════════════════════════════╣
║                                                                     ║
║  NEXT STEPS                                                         ║
║  ─────────────────────────────────────────────────────────────────  ║
║  1. Wallpaper: wallhaven.cc → search "forest HDR golden hour 4K"   ║
║     Or run: osascript -e 'tell app "Finder" to set desktop picture  ║
║     of desktop 1 to POSIX file "/path/to/wallpaper.jpg"'           ║
║                                                                     ║
║  2. Ghostty theme: if GruvboxDarkHard fails, open Ghostty and run  ║
║     :theme then search "gruvbox" to find the exact name.           ║
║                                                                     ║
║  3. AeroSpace: log out & back in for start-at-login to take effect. ║
║     Until then: open -a AeroSpace manually.                         ║
║                                                                     ║
║  4. SketchyBar icons: the sketchybar-app-font maps app names to    ║
║     icons. If icons look wrong, check ~/.config/sketchybar/         ║
║     plugins/icon_map.sh and match character codepoints to your      ║
║     installed font version.                                          ║
║                                                                     ║
║  5. Flip clock: open Übersicht → it should auto-load from widgets/  ║
║     If not: Übersicht menu → Refresh All Widgets.                   ║
║                                                                     ║
║  6. Borders: if windows have no border, run manually:               ║
║     ~/.config/borders/bordersrc &                                    ║
║     Add to AeroSpace after-startup-command for persistence.          ║
║                                                                     ║
╚═════════════════════════════════════════════════════════════════════╝
DONE
