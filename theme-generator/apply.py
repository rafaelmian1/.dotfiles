"""Render every theme into themes/<name>/ plus the shared configs.

Unlike the old branch-per-theme layout, every theme is generated side by
side and the active one is chosen at runtime by theme-set, which reads
~/.theme and points symlinks at themes/<name>/.
"""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from palettes import THEMES
from nvim_themes import NVIM
import raycast
import render

REPO = os.path.expanduser("~/.dotfiles")


def w(rel, content, mode=None):
    path = os.path.join(REPO, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(content)
    if mode:
        os.chmod(path, mode)
    return rel


def render_theme(slug):
    """Write one theme's files under themes/<slug>/."""
    theme = THEMES[slug]
    out = []
    base = f"themes/{slug}"

    for mode in ("dark", "light"):
        variant = theme[mode]["variant"]
        out.append(w(f"{base}/kitty-{variant}.conf", render.kitty_conf(theme, mode)))
        p = theme[mode]
        out.append(w(f"{base}/k9s-{variant}.yaml",
                     render.K9S_SKIN.format(display=theme["display"],
                                            upstream=theme["nvim_plugin"], **p)))

    out.append(w(f"{base}/kitty-opacity.conf", render.kitty_opacity(theme)))
    # tmux and its status line need a light and a dark variant of their own,
    # or the bar stays dark when macOS switches to light mode.
    for mode in ("dark", "light"):
        variant = theme[mode]["variant"]
        out.append(w(f"{base}/tmux-powerline-{variant}.sh",
                     render.powerline_theme(theme, slug, mode)))
        out.append(w(f"{base}/tmux-{variant}.conf",
                     render.tmux_colors(theme, mode) + "\n"))
    # Two ready-made lazygit configs; theme-set links whichever matches the
    # current macOS appearance. delta needs the flag baked in, and layering
    # config files is not something lazygit does predictably.
    out.append(w(f"{base}/lazygit-dark.yml", render.lazygit_conf(theme, "dark")))
    out.append(w(f"{base}/lazygit-light.yml", render.lazygit_conf(theme, "light")))
    out.append(w(f"{base}/colorscheme.lua", NVIM[slug]))
    out.append(w(f"{base}/theme.env", render.theme_env(theme, slug)))
    return out


def render_all():
    out = []
    for slug in sorted(THEMES):
        out += render_theme(slug)
    # One Raycast command per theme; regenerated together so a new theme
    # gets its command without a separate step.
    out += [os.path.relpath(p, REPO) for p in raycast.generate()]
    return out


if __name__ == "__main__":
    targets = sys.argv[1:] or sorted(THEMES)
    for slug in targets:
        if slug not in THEMES:
            raise SystemExit(f"unknown theme: {slug}")
    for f in (render_all() if not sys.argv[1:] else
              [x for s in targets for x in render_theme(s)]):
        print("  wrote", f)
