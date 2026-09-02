#!/bin/bash

# Raycast Script Command — step to the next colour theme.
# Handy on a hotkey: press repeatedly to flip through the themes.
#
# @raycast.schemaVersion 1
# @raycast.title Cycle Terminal Theme
# @raycast.mode compact
# @raycast.packageName Dotfiles
#
# @raycast.icon 🔄
# @raycast.description Switch to the next colour theme in the list
# @raycast.author Rafael Mian

set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
THEMES_DIR="$DOTFILES/themes"

# Built with a loop rather than mapfile: macOS ships bash 3.2 as /bin/bash.
themes=()
while IFS= read -r name; do
  themes+=("$name")
done < <(find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)
[ "${#themes[@]}" -gt 0 ] || { echo "No themes found in $THEMES_DIR" >&2; exit 1; }

current="$(tr -d '[:space:]' <"$HOME/.theme" 2>/dev/null || true)"

# Find the current theme's position, then take the one after it.
next="${themes[0]}"
for i in "${!themes[@]}"; do
  if [ "${themes[$i]}" = "$current" ]; then
    next="${themes[$(((i + 1) % ${#themes[@]}))]}"
    break
  fi
done

exec "$DOTFILES/theme-set" "$next"
