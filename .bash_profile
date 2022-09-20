#!/usr/bin/env bash

# Set `VERBOSITY` to show debug messages in imported scripts
# VERBOSITY="1"

# If a file exists and is not empty, source it. Otherwise, return an falsy value
import() {
	# shellcheck disable=SC1090
	[ -r "$1" ] && source "$1"
}

# Load in extensions…
# NOTE: `{*,.[!.]*}` matches all files in the current directory and loads hidden files **last**
for file in "${HOME}/.bash_profile_extensions"/{*,.[!.]*}; do
	import "${file}"
done
