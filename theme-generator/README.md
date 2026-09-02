# theme-generator

Generates the files under `themes/<name>/` for every colour theme, so the
themes differ only by palette rather than drifting apart in structure.

Themes are chosen at runtime, not by git branch: `~/.theme` holds the active
name and `theme-set` points a handful of symlinks at `themes/<name>/`.

## Usage

    python3 theme-generator/apply.py              # regenerate every theme
    python3 theme-generator/apply.py kanagawa     # just one

Each theme directory gets:

| File | Consumed by |
|---|---|
| `kitty-<variant>.conf` | kitty, via `current-theme.conf` |
| `kitty-opacity.conf` | kitty, via `current-opacity.conf` |
| `tmux.conf` | tmux, sourced as `current-theme.conf` |
| `tmux-powerline.sh` | tmux-powerline, as the `current` theme |
| `k9s-<variant>.yaml` | k9s, as the `current` skin |
| `lazygit-dark.yml`, `lazygit-light.yml` | lazygit, one per appearance |
| `colorscheme.lua` | nvim, loaded by `lua/plugins/colorscheme.lua` |
| `theme.env` | `theme-set` and nvim's `lua/config/theme.lua` |

Regenerating is safe: it overwrites only generated files, and running it
with no changes to `palettes.py` should produce no git diff.

## Files

- `palettes.py` — the colours. One entry per theme, each with a `dark` and
  `light` variant using shared semantic keys (`bg`, `fg`, `bg_p1`, `muted`,
  `red`, …) so one template works for every theme. `transparent` controls
  whether kitty is translucent.
- `render.py` — templates for everything except nvim.
- `nvim_themes.py` — each theme's nvim spec, written by hand because every
  colorscheme plugin has a different options API.
- `apply.py` — writes the files.

## Adding a theme

1. Add an entry to `THEMES` in `palettes.py` with every key the existing
   entries use.
2. Add the matching nvim spec to `NVIM` in `nvim_themes.py`. Point its
   dark-notify `schemes` at the variant names you used.
3. `python3 theme-generator/apply.py <name>`
4. `./theme-set <name>` and check it:
   - `nvim --headless "+Lazy! sync" +qa`, then confirm `vim.g.colors_name`
     and that `Normal`'s background matches the kitty background
   - toggle macOS appearance and confirm the light variant follows
