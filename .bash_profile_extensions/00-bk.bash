#!/usr/bin/env bash

# Cursor movement
ansi_cursor_home='\e[H'
ansi_cursor_absolute='\e[%d;%dH'
ansi_cursor_up='\e[%dA'
ansi_cursor_down='\e[%dB'
ansi_cursor_right='\e[%dC'
ansi_cursor_left='\e[%dD'
ansi_cursor_absolute_column='\e[%dG'
ansi_cursor_save='\e[s'
ansi_cursor_restore='\e[u'

# Clearing
ansi_clear_screen='\e[2J'
ansi_clear_saved_lines='\e[3J'
ansi_clear_line_to_end='\e[0K'
ansi_clear_line_to_start='\e[1K'
ansi_clear_line='\e[2K'

# Formatting
ansi_reset='\e[0m'
ansi_bold='\e[1m'
ansi_end_bold='\e[22m'
ansi_dim='\e[2m'
ansi_end_dim='\e[22m'
ansi_italic='\e[3m'
ansi_end_italic='\e[23m'
ansi_underline='\e[4m'
ansi_end_underline='\e[24m'
ansi_blink='\e[5m'
ansi_end_blink='\e[25m'
ansi_invert='\e[7m'
ansi_end_invert='\e[27m'
ansi_hidden='\e[8m'
ansi_end_hidden='\e[28m'
ansi_strikethrough='\e[9m'
ansi_end_strikethrough='\e[29m'

# Colors
ansi_black='\e[30m'
ansi_red='\e[31m'
ansi_green='\e[32m'
ansi_yellow='\e[33m'
ansi_blue='\e[34m'
ansi_magenta='\e[35m'
ansi_cyan='\e[36m'
ansi_white='\e[37m'
ansi_default='\e[39m'
ansi_bg_black='\e[40m'
ansi_bg_red='\e[41m'
ansi_bg_green='\e[42m'
ansi_bg_yellow='\e[43m'
ansi_bg_blue='\e[44m'
ansi_bg_magenta='\e[45m'
ansi_bg_cyan='\e[46m'
ansi_bg_white='\e[47m'
ansi_bg_default='\e[49m'
ansi_bright_black='\e[90m'
ansi_bright_red='\e[91m'
ansi_bright_green='\e[92m'
ansi_bright_yellow='\e[93m'
ansi_bright_blue='\e[94m'
ansi_bright_magenta='\e[95m'
ansi_bright_cyan='\e[96m'
ansi_bright_white='\e[97m'
ansi_bg_bright_black='\e[100m'
ansi_bg_bright_red='\e[101m'
ansi_bg_bright_green='\e[102m'
ansi_bg_bright_yellow='\e[103m'
ansi_bg_bright_blue='\e[104m'
ansi_bg_bright_magenta='\e[105m'
ansi_bg_bright_cyan='\e[106m'
ansi_bg_bright_white='\e[107m'
ansi_fg='\e[38;2;%d;%d;%dm'
ansi_bg='\e[48;2;%d;%d;%dm'

##
# Converts either #RRGGBB or #RGB to RGB values
##
bk.hex_to_rgb() {
	local hex="$1"
	local r g b

	if [[ $hex =~ ^#([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})$ ]]; then
		r=$((16#${BASH_REMATCH[1]}))
		g=$((16#${BASH_REMATCH[2]}))
		b=$((16#${BASH_REMATCH[3]}))
	elif [[ $hex =~ ^#([0-9a-fA-F])([0-9a-fA-F])([0-9a-fA-F])$ ]]; then
		# Need to double the values for single digit hex values
		r=$((16#${BASH_REMATCH[1]} * 17))
		g=$((16#${BASH_REMATCH[2]} * 17))
		b=$((16#${BASH_REMATCH[3]} * 17))
	else
		return 1
	fi

	printf '%d %d %d' "$r" "$g" "$b"
}

##
# Commands for common ANSI escape sequences
##
bk.term.ansi() {
	local command="ansi_${1%:*}"
	local args="${1#*:}"

	if [[ -z ${!command} ]]; then
		echo "Unknown ANSI command: $command" >&2
		return 1
	fi

	# If there are arguments, replace the placeholders.
	# Multiple args are comma-separated.
	case $command in
		"ansi_fg" | "ansi_bg")
			rgb=($(bk.hex_to_rgb "$args"))
			printf "${!command}" "${rgb[@]}"
			;;
		"ansi_cursor_absolute")
			IFS=',' read -r row col <<<"$args"
			printf "${!command}" "$row" "$col"
			;;
		"ansi_cursor_up" | "ansi_cursor_down" | "ansi_cursor_right" | "ansi_cursor_left" | "ansi_cursor_absolute_column")
			printf "${!command}" "$args"
			;;
		*)
			printf "${!command}"
			;;
	esac
}

##
# Decorate a string with ANSI codes
#
# Examples:
#   # Color some text
#   bk.term.decorate 'This is a %{yellow}warning%{reset} message\n'
#   # Text formatting
#   bk.term.decorate 'This is a %{bold}bold%{end_bold}, %{underline}underlined%{end_underline}, and %{italic}italicized%{end_italic} message.\n'
#   # Set the foreground and background colors using hex values
#   bk.term.decorate 'This is a %{fg:#ff0000}red%{reset} and %{bg:#00ff00}green%{reset} message\n'
#   # Cursor movement
#   bk.term.decorate '███%{cursor_down}%{cursor_left}███\n'
##
bk.term.decorate() {
	local string="$1"

	# Replace %{...} with the actual codes
	while [[ $string =~ ^(.*)%\{([^}]+)\}(.*)$ ]]; do
		before_match="${BASH_REMATCH[1]}"
		code_name="${BASH_REMATCH[2]}"
		ansi_code="$(bk.term.ansi "$code_name")"
		rest="${BASH_REMATCH[3]}"

		string="${before_match}${ansi_code}${rest}"
	done

	echo -en "$string"
}
