#!/usr/bin/env bash

# The root directory of the dotfiles repository
DOTFILES_ROOT="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
export DOTFILES_ROOT

# Set `VERBOSITY` to show debug messages in imported scripts
# You can also test by using `VERBOSITY=1 bash -lc true`
# VERBOSITY="1"

# If a file exists and is not empty, source it. Otherwise, return an falsy value
import() {
	# shellcheck disable=SC1090
	[ -r "$1" ] && source "$1"
}

##
# Prints the current time in microseconds. This is used to track how long it takes to load each extension.
##
usec() {
	# The decimal is locale-dependent, so we need to remove it to get a pure number
	echo "${EPOCHREALTIME//[!0-9]/}"
}

# Load in extensions in a natural sort order
for file in $(find -L "${HOME}/.bash_profile_extensions" -type f | sort -d); do
	# Track start time if `VERBOSITY` is set
	if [[ ${VERBOSITY-} != '' ]]; then
		export DOTFILES_IMPORT_TIME_START
		DOTFILES_IMPORT_TIME_START=$(usec)
	fi

	import "${file}"
done
