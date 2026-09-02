# shellcheck shell=bash
# Kanagawa theme for tmux-powerline.
# If changes made here does not take effect, then try to re-create the tmux
# session to force reload.

if patched_font_in_use; then
	TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
	TMUX_POWERLINE_SEPARATOR_LEFT_THIN=""
	TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
	TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=""
else
	TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◀"
	TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
	TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="▶"
	TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
fi

# Kanagawa palette. Hex values are used throughout rather than
# 256-colour indices so the status line matches the terminal theme exactly
# instead of depending on however the terminal happens to map colour0-15.
# tp_bg must match status-style in tmux.conf: it is what the window list and
# the outer separators are drawn against, so any mismatch shows up as a band.
tp_bg="#2a2a37"
tp_surface="#2d4f67"
tp_selection="#16161d"
tp_fg="#dcd7ba"
tp_fg_dim="#c8c093"
tp_muted="#727169"
tp_blue="#7e9cd8"
tp_green="#76946a"
tp_yellow="#c0a36e"
tp_magenta="#957fb8"
tp_cyan="#6a9589"
tp_red="#c34043"

# Segment backgrounds, darkened where the palette had no legible ink for
# the original accent, with the text colour each one earned.
tp_seg_session="#7e9cd8"
tp_seg_pwd="#2d4f67"
tp_seg_now_playing="#2d4f67"
tp_seg_battery="#2d4f67"
tp_seg_date="#16161d"
tp_seg_time="#c0a36e"
tp_ink_session="#16161d"
tp_ink_pwd="#dcd7ba"
tp_ink_now_playing="#dcd7ba"
tp_ink_battery="#dcd7ba"
tp_ink_date="#dcd7ba"
tp_ink_time="#16161d"
# Current-window text, on the same yellow accent as the clock.
tp_contrast="#16161d"

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-$tp_bg}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-$tp_fg_dim}
# shellcheck disable=SC2034
TMUX_POWERLINE_SEG_AIR_COLOR=$(air_color)

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}

# shellcheck disable=SC2128
if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_CURRENT" ]; then
	TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
		"#[fg=${tp_contrast},bg=${tp_seg_time}]"
		"$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
		" #I#F "
		"$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN"
		" #W "
		"#[fg=${tp_seg_time},bg=${tp_bg}]"
		"$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
	)
fi

# shellcheck disable=SC2128
if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_STYLE" ]; then
	TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
		"fg=${tp_muted},bg=${tp_bg}"
	)
fi

# shellcheck disable=SC2128
if [ -z "$TMUX_POWERLINE_WINDOW_STATUS_FORMAT" ]; then
	TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
		"#[fg=${tp_muted},bg=${tp_bg}]"
		"  #I#{?window_flags,#F, } "
		"$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN"
		" #W "
	)
fi

# Format: segment_name [background_color|default_bg_color] [foreground_color|default_fg_color] [non_default_separator|default_separator] [separator_background_color|no_sep_bg_color]
#                      [separator_foreground_color|no_sep_fg_color] [spacing_disable|no_spacing_disable] [separator_disable|no_separator_disable]
#
# See the upstream default.sh theme for the full documentation of these fields.

# shellcheck disable=SC1143,SC2128
if [ -z "$TMUX_POWERLINE_LEFT_STATUS_SEGMENTS" ]; then
	TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
		"tmux_session_info ${tp_seg_session} ${tp_ink_session}"
		"pwd ${tp_seg_pwd} ${tp_ink_pwd}"
	)
fi

# shellcheck disable=SC1143,SC2128
if [ -z "$TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS" ]; then
	TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
		"now_playing ${tp_seg_now_playing} ${tp_ink_now_playing}"
		"battery ${tp_seg_battery} ${tp_ink_battery}"
		"date ${tp_seg_date} ${tp_ink_date}"
		"time ${tp_seg_time} ${tp_ink_time}"
	)
fi
