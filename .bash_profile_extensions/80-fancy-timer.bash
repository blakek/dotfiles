#!/usr/bin/env bash

##
# A fancy timer that:
# - Can show time remaining, time elapsed, etc.
# - Can show a custom message
# - Can parse a time string (e.g. 1h30m20s)
# - Shows a reverse progress bar for a larger indicator of time remaining
##

fancy_timer_version="1.0.0-alpha.1"

bold() {
	echo -e "\033[1m$*\033[0m"
}

show_usage() {
	cat <<-END
		$(bold fancy_timer) - A fancy timer for the command line

		$(bold USAGE EXAMPLES)
		    # Set a 20 mintue timer
		    fancy_timer 20m

		    # Set a 1 hour timer with a custom message and no progress bar
		    fancy_timer --no-progress -m "Time remaining: %r" 1h

		$(bold OPTIONS)
		    -h, --help     output usage information and exit
		    -m, --message  a template message to display; see below for syntax
		    -v, --version  output the version number and exit

		    --no-elapsed   disable the time elapsed indicator
		    --no-progress  disable the progress bar
		    --no-remaining disable the time remaining indicator

		$(bold ARGUMENTS)
		    time      time to count down from (e.g. 1h23m45s)

		$(bold MESSAGE SYNTAX)
		    The message is a string where the following are replaced:
		        %r  time remaining
		        %e  time elapsed
		        %t  total time

		    Note, all time values are in the format 1h23m45s.
	END
}

##
# Parse a time string (e.g. 1h30m20s) into seconds
##
parse_time() {
	local time_string="$1"
	local total_seconds=0
	local hours=0
	local minutes=0
	local seconds=0

	# Extract hours
	if [[ $time_string =~ ([0-9]+)h ]]; then
		hours=${BASH_REMATCH[1]}
	fi

	# Extract minutes
	if [[ $time_string =~ ([0-9]+)m ]]; then
		minutes=${BASH_REMATCH[1]}
	fi

	# Extract seconds
	if [[ $time_string =~ ([0-9]+)s ]]; then
		seconds=${BASH_REMATCH[1]}
	fi

	# Convert all to seconds
	total_seconds=$((hours * 3600 + minutes * 60 + seconds))

	echo $total_seconds
}

##
# Format a time in seconds into a human-readable string
##
format_time() {
	local time="$1"
	local hours=$((time / 3600))
	local minutes=$((time % 3600 / 60))
	local seconds=$((time % 60))

	# Only show the smallest units necessary
	if [[ $hours -gt 0 ]]; then
		printf '%dh' $hours
	fi

	if [[ $minutes -gt 0 || $hours -gt 0 ]]; then
		printf '%dm' $minutes
	fi

	printf '%ds' $seconds
}

fancy_timer() {
	local time=0
	local message="%r remaining"
	local progress=true
	local remaining=true
	local elapsed=true

	local ansi_invert="\033[7m"
	local ansi_reset="\033[0m"
	local ansi_clear_line="\033[K"

	# Parse arguments
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-h | --help)
				show_usage
				return
				;;
			-v | --version)
				echo "$fancy_timer_version"
				return
				;;
			-m | --message)
				message="$2"
				shift 2
				;;
			--no-progress)
				progress=false
				shift
				;;
			--no-remaining)
				remaining=false
				shift
				;;
			--no-elapsed)
				elapsed=false
				shift
				;;
			*)
				time=$(parse_time "$1")
				shift
				;;
		esac
	done

	# Validate arguments
	if [[ $time -eq 0 ]]; then
		echo "Failed to parse time"
		return
	fi

	# Start the timer
	local start_time=$(date +%s)
	local end_time=$((start_time + time))

	# Main loop
	while [[ $(date +%s) -lt $end_time ]]; do
		local current_time=$(date +%s)
		local elapsed_time=$((current_time - start_time))
		local remaining_time=$((end_time - current_time))

		# Calculate the message
		local message_string=${message//\%r/$(format_time $remaining_time)}
		message_string=${message_string//\%e/$(format_time $elapsed_time)}
		message_string=${message_string//\%t/$(format_time $time)}

		if $progress; then
			# Calculate the progress. Note that we invert the percentage by not subtracting from 100.
			local progress_percent=$((remaining_time * 100 / time))

			# The progress bar is the width of the terminal
			# We invert the background and foreground colors so it looks like a progress bar
			local column_count=$(tput cols)
			local progress_columns=$((column_count * progress_percent / 100))
			local remaining_columns=$((column_count - progress_columns))

			# Draw the progress bar with the message, adding padding to any remaining space
			printf '\r%b%-*.*s%b%-*.*s%b' \
				"$ansi_invert" \
				$progress_columns $progress_columns "$message_string" \
				"$ansi_reset" \
				$remaining_columns $remaining_columns "${message_string:progress_columns}" \
				"$ansi_clear_line"

		else
			printf "\r%s" "$message_string"
		fi

		# Sleep for a second
		sleep 1
	done

	# Print the final message
	printf "\r%s%b\n" "$message_string" "$ansi_clear_line"
}

export -f fancy_timer
