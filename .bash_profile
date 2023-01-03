#!/usr/bin/env bash

# Set `VERBOSITY` to show debug messages in imported scripts
# VERBOSITY="1"

# If a file exists and is not empty, source it. Otherwise, return an falsy value
import() {
	# shellcheck disable=SC1090
	[ -r "$1" ] && source "$1"
}

# Load in extensions in a natural sort order
for file in $(find -L "${HOME}/.bash_profile_extensions" -type f | sort -d); do
	import "${file}"
done
