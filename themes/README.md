# themes

One directory per colour theme. The active theme is whatever `~/.theme`
contains; `theme-set` reads it and points symlinks here.

    theme-set                  # show the active theme and list the rest
    theme-set tokyo-night      # switch
    theme-set --reload         # re-apply, picking up a light/dark change

`~/.theme` is deliberately untracked: it is per-machine state, so two
machines can run different themes from the same checkout.

## How a theme reaches each program

Nothing in this repo is rewritten when you switch — only symlinks move.

| Program | Link | Points at |
|---|---|---|
| kitty | `~/.config/kitty/current-theme.conf` | `kitty-<variant>.conf` |
| kitty | `~/.config/kitty/current-opacity.conf` | `kitty-opacity.conf` |
| tmux | `~/.config/tmux/current-theme.conf` | `tmux.conf` |
| tmux-powerline | `.config/tmux-powerline/themes/current.sh` | `tmux-powerline.sh` |
| k9s | `…/k9s/skins/current.yaml` | `k9s-<variant>.yaml` |
| lazygit | `…/lazygit/config.yml` | `lazygit-dark.yml` or `-light.yml` |
| nvim | reads `~/.theme` directly | `colorscheme.lua` |

## Switching from inside nvim

    <leader>uc      pick a theme
    :Theme          same picker
    :Theme <name>   switch directly

This applies the colorscheme in the running instance *and* runs `theme-set`,
so kitty, tmux, k9s and lazygit follow. Every theme's plugin is installed but
only the active one loads at startup, so switching is instant and costs
nothing when you don't use it.

`<variant>` is the theme's own name for its dark and light modes (Kanagawa
calls them wave and lotus, Rosé Pine moon and dawn), listed in `theme.env`.

macOS appearance changes are handled by dark-notify calling `switch_theme`,
which just runs `theme-set --reload`.

## Editing

These files are generated — see `theme-generator/`. Change the palette
there and regenerate, rather than editing a theme by hand.

Every nvim opens an RPC socket under `$TMPDIR/nvim.$USER/`, and `theme-set`
applies the theme through each one. So a switch from the shell, from Raycast,
or from a macOS appearance change reaches editors that are already open —
no restart, and no need to use `<leader>uc` unless you prefer the picker.
