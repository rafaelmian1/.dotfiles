"""Templates for the generated theme files."""


def _luminance(hex_colour):
    """Relative luminance of a #rrggbb colour, per WCAG."""
    h = hex_colour.lstrip("#")
    channels = []
    for i in (0, 2, 4):
        c = int(h[i:i + 2], 16) / 255
        channels.append(c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4)
    r, g, b = channels
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def contrast_ratio(a, b):
    """WCAG contrast ratio between two #rrggbb colours (1.0 to 21.0)."""
    la, lb = sorted((_luminance(a), _luminance(b)), reverse=True)
    return (la + 0.05) / (lb + 0.05)


def readable_on(background, candidates):
    """Pick whichever candidate reads best against `background`.

    Segment backgrounds come from the palette's accent colours, which differ
    wildly in lightness between a theme's light and dark variants. Choosing
    the text colour by role alone produced dark-on-dark and light-on-light
    segments, so pick by measured contrast instead.
    """
    return max(candidates, key=lambda c: contrast_ratio(background, c))


def kitty_conf(theme, mode):
    p = theme[mode]
    return f"""## name: {theme['display']} ({p['variant']})
## upstream: {theme['nvim_plugin']}

foreground               {p['fg']}
background               {p['bg']}
selection_foreground     {p['sel_fg']}
selection_background     {p['bg_p2']}

cursor                   {p['cursor']}
cursor_text_color        {p['bg']}

url_color                {p['url']}

active_tab_foreground    {p['fg']}
active_tab_background    {p['tab_active_bg']}
inactive_tab_foreground  {p['tab_inactive_fg']}
inactive_tab_background  {p['bg']}

# black
color0   {p['black']}
color8   {p['bright_black']}

# red
color1   {p['red']}
color9   {p['bright_red']}

# green
color2   {p['green']}
color10  {p['bright_green']}

# yellow
color3   {p['yellow']}
color11  {p['bright_yellow']}

# blue
color4   {p['blue']}
color12  {p['bright_blue']}

# magenta
color5   {p['magenta']}
color13  {p['bright_magenta']}

# cyan
color6   {p['cyan']}
color14  {p['bright_cyan']}

# white
color7   {p['white']}
color15  {p['bright_white']}
"""


def shade(hex_colour, factor):
    """Lighten (factor > 1) or darken (factor < 1) a #rrggbb colour."""
    h = hex_colour.lstrip("#")
    parts = []
    for i in (0, 2, 4):
        v = int(int(h[i:i + 2], 16) * factor)
        parts.append(max(0, min(255, v)))
    return "#%02x%02x%02x" % tuple(parts)


def legible_pair(background, inks, target=4.5):
    """Return (background, ink) that clears `target` contrast.

    Light palettes pick mid-tone accents that no tone in the palette can sit
    on legibly, so darken the background progressively until one does.
    """
    best_ink = readable_on(background, inks)
    if contrast_ratio(background, best_ink) >= target:
        return background, best_ink
    for factor in (0.85, 0.72, 0.6, 0.5, 0.42, 0.35, 0.3):
        candidate = shade(background, factor)
        ink = readable_on(candidate, inks)
        if contrast_ratio(candidate, ink) >= target:
            return candidate, ink
    return background, best_ink


def powerline_theme(theme, slug, mode="dark"):
    d = theme[mode]

    # Ink candidates: the darkest and lightest tones the palette offers. Each
    # segment picks whichever of these reads better against its own
    # background, so accents that are dark in one variant and light in the
    # other stay legible without hand-tuning per theme.
    ink_dark = min((d["bg_dim"], d["bg"], d["fg"]), key=_luminance)
    ink_light = max((d["fg"], d["bg"], d["bg_dim"]), key=_luminance)
    inks = (ink_dark, ink_light)

    # Segment backgrounds, and the text colour each one earns.
    seg_bg = {
        "session": d["blue"],
        "pwd": d["bg_p2"],
        "now_playing": d["bg_p2"],
        "battery": d["bg_p2"],
        "date": d["bg_dim"],
        "time": d["yellow"],
    }
    # Darken a background where the palette offers no legible ink for it.
    pairs = {k: legible_pair(v, inks) for k, v in seg_bg.items()}
    seg_bg = {k: v[0] for k, v in pairs.items()}
    ink = {k: v[1] for k, v in pairs.items()}

    # The current window sits on the yellow accent, same as the clock.
    contrast = ink["time"]
    return f'''# shellcheck shell=bash
# {theme['display']} theme for tmux-powerline.
# If changes made here does not take effect, then try to re-create the tmux
# session to force reload.

if patched_font_in_use; then
\tTMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
\tTMUX_POWERLINE_SEPARATOR_LEFT_THIN=""
\tTMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
\tTMUX_POWERLINE_SEPARATOR_RIGHT_THIN=""
else
\tTMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◀"
\tTMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
\tTMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="▶"
\tTMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
fi

# {theme['display']} palette. Hex values are used throughout rather than
# 256-colour indices so the status line matches the terminal theme exactly
# instead of depending on however the terminal happens to map colour0-15.
# tp_bg must match status-style in tmux.conf: it is what the window list and
# the outer separators are drawn against, so any mismatch shows up as a band.
tp_bg="{d['bg_p1']}"
tp_surface="{d['bg_p2']}"
tp_selection="{d['bg_dim']}"
tp_fg="{d['fg']}"
tp_fg_dim="{d['fg_dim']}"
tp_muted="{d['muted']}"
tp_blue="{d['blue']}"
tp_green="{d['green']}"
tp_yellow="{d['yellow']}"
tp_magenta="{d['magenta']}"
tp_cyan="{d['cyan']}"
tp_red="{d['red']}"

# Segment backgrounds, darkened where the palette had no legible ink for
# the original accent, with the text colour each one earned.
tp_seg_session="{seg_bg['session']}"
tp_seg_pwd="{seg_bg['pwd']}"
tp_seg_now_playing="{seg_bg['now_playing']}"
tp_seg_battery="{seg_bg['battery']}"
tp_seg_date="{seg_bg['date']}"
tp_seg_time="{seg_bg['time']}"
tp_ink_session="{ink['session']}"
tp_ink_pwd="{ink['pwd']}"
tp_ink_now_playing="{ink['now_playing']}"
tp_ink_battery="{ink['battery']}"
tp_ink_date="{ink['date']}"
tp_ink_time="{ink['time']}"
# Current-window text, on the same yellow accent as the clock.
tp_contrast="{contrast}"

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${{TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-$tp_bg}}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${{TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-$tp_fg_dim}}
# shellcheck disable=SC2034
TMUX_POWERLINE_SEG_AIR_COLOR=$(air_color)

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${{TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${{TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}}

# shellcheck disable=SC2128
if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_CURRENT" ]; then
\tTMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
\t\t"#[fg=${{tp_contrast}},bg=${{tp_seg_time}}]"
\t\t"$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
\t\t" #I#F "
\t\t"$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN"
\t\t" #W "
\t\t"#[fg=${{tp_seg_time}},bg=${{tp_bg}}]"
\t\t"$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
\t)
fi

# shellcheck disable=SC2128
if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_STYLE" ]; then
\tTMUX_POWERLINE_WINDOW_STATUS_STYLE=(
\t\t"fg=${{tp_muted}},bg=${{tp_bg}}"
\t)
fi

# shellcheck disable=SC2128
if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_FORMAT" ]; then
\tTMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
\t\t"#[fg=${{tp_muted}},bg=${{tp_bg}}]"
\t\t"  #I#{{?window_flags,#F, }} "
\t\t"$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN"
\t\t" #W "
\t)
fi

# Format: segment_name [background_color|default_bg_color] [foreground_color|default_fg_color] [non_default_separator|default_separator] [separator_background_color|no_sep_bg_color]
#                      [separator_foreground_color|no_sep_fg_color] [spacing_disable|no_spacing_disable] [separator_disable|no_separator_disable]
#
# See the upstream default.sh theme for the full documentation of these fields.

# shellcheck disable=SC1143,SC2128
if [ -z "$TMUX_POWERLINE_LEFT_STATUS_SEGMENTS" ]; then
\tTMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
\t\t"tmux_session_info ${{tp_seg_session}} ${{tp_ink_session}}"
\t\t"pwd ${{tp_seg_pwd}} ${{tp_ink_pwd}}"
\t)
fi

# shellcheck disable=SC1143,SC2128
if [ -z "$TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS" ]; then
\tTMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
\t\t"now_playing ${{tp_seg_now_playing}} ${{tp_ink_now_playing}}"
\t\t"battery ${{tp_seg_battery}} ${{tp_ink_battery}}"
\t\t"date ${{tp_seg_date}} ${{tp_ink_date}}"
\t\t"time ${{tp_seg_time}} ${{tp_ink_time}}"
\t)
fi
'''


def tmux_colors(theme, mode="dark"):
    d = theme[mode]
    # Text drawn on the yellow accent. Light palettes put dark text on it —
    # every light background tone measures under 2.2:1 against the accent,
    # while the foreground reaches ~3.2:1.
    contrast = d["fg"] if mode == "light" else d["bg_dim"]
    return f"""set -g status on
set-option -g status-position bottom

# The status line background shows through wherever tmux-powerline draws no
# segment — the gaps either side of the window list. Use the same surface the
# segments sit on so those gaps read as part of the bar rather than as a dark
# band across it.
set -g status-style bg={d['bg_p1']},fg={d['fg_dim']}

# {theme['display']} accents. tmux-powerline (below) repaints the status line
# itself but not pane borders or the command/message line, so set those
# explicitly here. Hex values keep these in step with the powerline theme
# regardless of how the terminal maps colour0-15.
set -g pane-border-style fg={d['bg_p1']}
set -g pane-active-border-style fg={d['blue']}
set -g message-style bg={d['yellow']},fg={contrast}
set -g message-command-style bg={d['yellow']},fg={contrast}
set -g window-status-current-style bg={d['yellow']},fg={contrast},bold
set -g mode-style bg={d['bg_p2']},fg={d['fg']}
"""


K9S_SKIN = """# -----------------------------------------------------------------------------
# {display} ({variant})
# {upstream}
# -----------------------------------------------------------------------------
#
text: &text "{fg}"
base: &base "{bg}"
overlay: &overlay "{bg_p1}"
muted: &muted "{muted}"
rose: &rose "{magenta}"
pine: &pine "{green}"
gold: &gold "{yellow}"
iris: &iris "{blue}"
love: &love "{red}"

# Skin...
k9s:
  # General K9s styles
  body:
    fgColor: *text
    bgColor: *base
    logoColor: *iris
  # Command prompt styles
  prompt:
    fgColor: *text
    bgColor: *base
    suggestColor: *iris
  # ClusterInfoView styles.
  info:
    fgColor: *iris
    sectionColor: *text
  # Dialog styles.
  dialog:
    fgColor: *text
    bgColor: *base
    buttonFgColor: *text
    buttonBgColor: *iris
    buttonFocusFgColor: *gold
    buttonFocusBgColor: *iris
    labelFgColor: *gold
    fieldFgColor: *text
  frame:
    # Borders styles.
    border:
      fgColor: *overlay
      focusColor: *overlay
    menu:
      fgColor: *text
      keyColor: *iris
      # Used for favorite namespaces
      numKeyColor: *iris
    # CrumbView attributes for history navigation.
    crumbs:
      fgColor: *text
      bgColor: *overlay
      activeColor: *overlay
    # Resource status and update styles
    status:
      newColor: *rose
      modifyColor: *iris
      addColor: *pine
      errorColor: *love
      highlightcolor: *gold
      killColor: *muted
      completedColor: *muted
    # Border title styles.
    title:
      fgColor: *text
      bgColor: *overlay
      highlightColor: *gold
      counterColor: *iris
      filterColor: *iris
  views:
    # Charts skins...
    charts:
      bgColor: default
      defaultDialColors:
        - *iris
        - *love
      defaultChartColors:
        - *iris
        - *love
    # TableView attributes.
    table:
      fgColor: *text
      bgColor: *base
      # Header row styles.
      header:
        fgColor: *text
        bgColor: *base
        sorterColor: *rose
    # Xray view attributes.
    xray:
      fgColor: *text
      bgColor: *base
      cursorColor: *overlay
      graphicColor: *iris
      showIcons: false
    # YAML info styles.
    yaml:
      keyColor: *iris
      colonColor: *iris
      valueColor: *text
    # Logs styles.
    logs:
      fgColor: *text
      bgColor: *base
      indicator:
        fgColor: *text
        bgColor: *iris
"""


def lazygit_conf(theme, delta="dark"):
    d = theme["dark"]
    return f"""gui:
  theme:
    activeBorderColor:
      - "{d['blue']}"
      - bold
    inactiveBorderColor:
      - "{d['muted']}"
    searchingActiveBorderColor:
      - "{d['yellow']}"
      - bold
    optionsTextColor:
      - "{d['cyan']}"
    selectedLineBgColor:
      - "{d['bg_p2']}"
    inactiveViewSelectedLineBgColor:
      - "{d['bg_p1']}"
    defaultFgColor:
      - "{d['fg']}"
    cherryPickedCommitBgColor:
      - "{d['bg_p2']}"
    cherryPickedCommitFgColor:
      - "{d['magenta']}"
    unstagedChangesColor:
      - "{d['red']}"
git:
  pagers:
    - colorArg: always
      pager: delta --{delta} --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{{path}}:{{line}}"
os:
  edit: "nvr -cc vsplit --remote-wait +'set bufhidden=wipe' {{{{filename}}}}"
"""


def switch_theme(theme, slug):
    return f'''#!/bin/bash
# Swap the terminal stack between the {theme['display']} light and dark variants.
# Invoked by dark-mode-notify (see setup_theme_sync) with DARKMODE set.

set -u

KITTY_DIR="$HOME/.config/kitty"
K9S_SKINS="$HOME/Library/Application Support/k9s/skins"
LAZYGIT_CONFIG="$HOME/Library/Application Support/lazygit/config.yml"

if [ "${{DARKMODE:-0}}" = "1" ]; then
  KITTY_THEME="{slug}-{theme['dark']['variant']}.conf"
  K9S_SKIN="{slug}-{theme['dark']['variant']}.yaml"
  DELTA_FROM="delta --light"
  DELTA_TO="delta --dark"
else
  KITTY_THEME="{slug}-{theme['light']['variant']}.conf"
  K9S_SKIN="{slug}-{theme['light']['variant']}.yaml"
  DELTA_FROM="delta --dark"
  DELTA_TO="delta --light"
fi

cp "$KITTY_DIR/$KITTY_THEME" "$KITTY_DIR/current-theme.conf"

mkdir -p "$K9S_SKINS"
cp "$HOME/.dotfiles/k9s/$K9S_SKIN" "$K9S_SKINS/{slug}.yaml"

# lazygit has no light/dark switch of its own; flip the delta pager flag in
# place. Resolve symlinks first: the config is stowed from the repo, and BSD
# `sed -i` would otherwise replace the link with a regular file rather than
# editing the file it points at. Guard on existence so a fresh machine
# doesn't error here.
if [ -f "$LAZYGIT_CONFIG" ]; then
  LAZYGIT_TARGET="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$LAZYGIT_CONFIG")"
  sed -i '' "s/$DELTA_FROM/$DELTA_TO/g" "$LAZYGIT_TARGET"
fi

KITTY="/Applications/kitty.app/Contents/MacOS/kitty"

# Clean up stale sockets
for SOCKET in /tmp/kitty*; do
  [ -S "$SOCKET" ] && ! lsof "$SOCKET" 2>&1 | grep -q kitty && rm "$SOCKET"
done

# Update all active kitty instances
for SOCKET in /tmp/kitty*; do
  if [ -S "$SOCKET" ]; then
    "$KITTY" @ --to "unix:$SOCKET" set-colors -a "$KITTY_DIR/current-theme.conf"
  fi
done
'''


def theme_env(theme, slug):
    """Metadata about a theme, sourced by theme-set and read by nvim."""
    return f"""# {theme['display']} — generated by theme-generator, do not edit.
THEME_NAME="{slug}"
THEME_DISPLAY="{theme['display']}"
THEME_DARK_VARIANT="{theme['dark']['variant']}"
THEME_LIGHT_VARIANT="{theme['light']['variant']}"
THEME_DARK_SCHEME="{theme['dark']['scheme']}"
THEME_LIGHT_SCHEME="{theme['light']['scheme']}"
THEME_NVIM_COLORSCHEME="{theme['nvim_name']}"
THEME_LUALINE="{theme['lualine']}"
THEME_OPACITY="{'0.9'}"
"""


def kitty_opacity(theme):
    """background_opacity lives in its own file so kitty.conf stays static."""
    value = "0.9"
    note = "translucent, so the wallpaper shows through"
    return f"""# {theme['display']} — {note}. Generated by theme-generator.
background_opacity {value}
"""
