#!/bin/bash

# Raycast Script Command — re-apply the active theme.
# Useful after changing macOS appearance manually, or if a program was
# started before the last theme switch.
#
# @raycast.schemaVersion 1
# @raycast.title Reload Terminal Theme
# @raycast.mode compact
# @raycast.packageName Dotfiles
#
# @raycast.icon ♻️
# @raycast.description Re-apply the current theme, picking the light or dark variant
# @raycast.author Rafael Mian

set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
exec "$DOTFILES/theme-set" --reload
