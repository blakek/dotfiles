#!/usr/bin/env bash

isInstalled emulator && function android-emulator() {
	local device=$(emulator -list-avds | ipt)
	emulator -avd "${device}" -no-boot-anim -ranchu $@ &
}

# From https://github.com/mathiasbynens/dotfiles/blob/master/.functions
# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1")
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8"
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Git diff with diff-so-fancy
isInstalled diff-so-fancy && function gdf() {
	git diff --color "$@" | diff-so-fancy | less -R
}

function github() {
	github="$(type -fp github)"
	[[ github == '' ]] && echo '`github` is not installed' && return
	[[ $# -eq 0 ]] && "${github}" . || "${github}" "$@"
}

# From https://github.com/mathiasbynens/dotfiles/blob/master/.functions
# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .
	else
		open "$@"
	fi
}

# Open projects
isInstalled ipt && function p() {
	developDirectory="${HOME}/developer"
	projectDirectory=$(ls $developDirectory | ipt -M 'Choose a project' -a)
	if [[ $projectDirectory != '' ]]; then
		cd "${developDirectory}/${projectDirectory}" && code .
	fi
}

# Print ¯\_(ツ)_/¯ and copy to clipboard
function shrug() {
	if isInstalled clipboard; then
		echo '¯\_(ツ)_/¯' | tee /dev/tty | clipboard
	else
		echo '¯\_(ツ)_/¯'
	fi
}

# From https://github.com/mathiasbynens/dotfiles/blob/master/.functions
# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
isInstalled tree && function tre() {
	tree -aC -I '.git|.next|node_modules|bower_components' --dirsfirst "$@" | less -FRX
}
