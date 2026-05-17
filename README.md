# Deep Forest Gruvbox

> A macOS desktop rice built on Gruvbox Dark Hard — tiling WM, floating status bar, glowing window borders, and a split-flap clock. One command from zero to done.

---

## Stack

| Tool | Role |
|---|---|
| [AeroSpace](https://github.com/nikitabobko/AeroSpace) | i3-inspired tiling window manager |
| [SketchyBar](https://github.com/FelixKratz/SketchyBar) | Floating pill-style status bar |
| [JankyBorders](https://github.com/FelixKratz/JankyBorders) | Rounded, glowing window borders |
| [Ghostty](https://ghostty.org) | GPU-accelerated terminal |
| [Übersicht](https://tracesof.net/uebersicht/) | Split-flap flip clock widget |
| VictorMono Nerd Font | Typography throughout |

---

## Install

```bash
git clone https://github.com/austinhenry/austin-aerospace.git ~/src/austin-aerospace
cd ~/src/austin-aerospace
./install.sh
```

The script handles everything:

1. Installs Homebrew if missing
2. Taps `FelixKratz/formulae` and `nikitabobko/tap`
3. Installs all tools (formulae + casks)
4. Fetches `sketchybar-app-font` from GitHub releases
5. Symlinks all configs into `~/.config/` (backs up anything already there)
6. Detects open apps and writes AeroSpace workspace assignments
7. Deploys the flip-clock widget to Übersicht
8. Sets script permissions and starts SketchyBar + JankyBorders

> Existing configs are backed up to `~/.config-backup-<timestamp>/` before any symlinks are written.

---

## After Install

**Wallpaper** — wallhaven.cc, search `forest HDR golden hour 4K`

**AeroSpace** — log out and back in for start-at-login to take effect. Until then: `open -a AeroSpace`

**Ghostty theme** — if `Gruvbox Dark Hard` fails on your build, open Ghostty → `:theme` → search `gruvbox`

**Übersicht** — open the app and the flip clock auto-loads. If not: Übersicht menu → Refresh All Widgets

**Borders** — if windows have no border after reboot, run `~/.config/borders/bordersrc &` manually

---

## Keybindings

All bindings use `Alt` as the modifier.

### Focus & Move

| Key | Action |
|---|---|
| `Alt + H/J/K/L` | Focus left/down/up/right |
| `Alt + Shift + H/J/K/L` | Move window left/down/up/right |
| `Alt + Ctrl + H/L` | Resize width −/+50px |
| `Alt + Ctrl + K/J` | Resize height −/+50px |

### Workspaces

| Key | Action |
|---|---|
| `Alt + 1–9` | Switch to workspace |
| `Alt + Shift + 1–9` | Move window to workspace (and follow) |
| `Alt + Tab` | Toggle last workspace |
| `Alt + Shift + Tab` | Move workspace to next monitor |

### Utilities

| Key | Action |
|---|---|
| `Alt + Enter` | New Ghostty window |
| `Alt + Shift + F` | Toggle fullscreen |
| `Alt + Shift + ;` | Enter service mode |

### Service Mode (`Alt + Shift + ;`)

| Key | Action |
|---|---|
| `Esc` | Reload config → main mode |
| `R` | Flatten/reset workspace layout |
| `F` | Toggle float/tile for focused window |

---

## App → Workspace Assignments

| Workspace | App |
|---|---|
| 1 | Ghostty |
| 2 | Dia |
| 3 | Proton Mail |
| 4 | Signal |
| 5 | Messages |

Finder always floats. Run `./install.sh` again to regenerate assignments from whatever apps are currently open.

---

## Color Palette

All values are Gruvbox Dark Hard (`0xAARRGGBB`).

| Role | Color | Hex |
|---|---|---|
| Bar background | BG Hard @ 90% | `#1d2021` |
| Item pills | BG1 | `#3c3836` |
| Default text | Foreground | `#ebdbb2` |
| Active workspace | Green | `#b8bb26` |
| Calendar | Aqua | `#8ec07c` |
| Volume | Blue | `#83a598` |
| CPU warning | Yellow / Orange | `#fabd2f` / `#fe8019` |
| Battery critical | Red | `#fb4934` |
| Battery charging | Purple | `#d3869b` |
| Front app pill | Forest green | `#3e7a50` |
| Window border (active) | Green @ 85% | `#b8bb26` |

---

## File Layout

```
.
├── install.sh                      # One-shot setup script
├── config/
│   ├── aerospace/aerospace.toml    # AeroSpace layout + keybindings
│   ├── sketchybar/
│   │   ├── sketchybarrc            # Bar definition
│   │   ├── colors.sh               # Shared palette
│   │   └── plugins/                # battery, calendar, cpu, volume, spaces, front_app
│   ├── borders/bordersrc           # JankyBorders options
│   └── ghostty/config              # Terminal config
└── ubersicht/
    └── flip-clock.jsx              # Split-flap clock widget
```
