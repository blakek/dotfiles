#!/usr/bin/env bash

##
# Join a bash array using a delimiter (any string)
##
arrayJoin() {
	local -r delimiter="$1" firstElement="$2"
	shift 2
	printf '%s' "$firstElement" "${@/#/$delimiter}"
}

##
# Return truthy/falsy value indicating if every argument is installed
# (i.e. found in hash lookup)
##
isInstalled() {
	hash "$@" 2>/dev/null
}

##
# Create a data URL from a file
# From https://github.com/mathiasbynens/dotfiles/blob/master/.functions
##
dataurl() {
	local mimeType=$(file -b --mime-type "$1")
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8"
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

##
# Git diff with diff-so-fancy
##
isInstalled diff-so-fancy && gdf() {
	git diff --color "$@" | diff-so-fancy | less -R
}

##
# Add defaults to the default GitHub Desktop CLI
##
github() {
	local -r originalScript="$(type -fp github)"
	[[ $originalScript == '' ]] && echo '`github` is not installed' && return
	([[ $# -eq 0 ]] && "${originalScript}" .) || "${originalScript}" "$@"
}

##
# `o` with no arguments opens the current directory, otherwise opens the given
# location
# From https://github.com/mathiasbynens/dotfiles/blob/master/.functions
##
o() {
	if [ $# -eq 0 ]; then
		open .
	else
		open "$@"
	fi
}

##
# Open projects
##
isInstalled ipt && p() {
	developDirectory="${HOME}/dev"
	projectDirectory=$(ls $developDirectory | ipt -M 'Choose a project' -a)
	if [[ $projectDirectory != '' ]]; then
		cd "${developDirectory}/${projectDirectory}" && code .
	fi
}

##
# Print ¯\_(ツ)_/¯ and copy to clipboard
##
shrug() {
	if isInstalled clipboard; then
		echo '¯\_(ツ)_/¯' | tee /dev/tty | clipboard
	elif isInstalled pbcopy; then
		echo '¯\_(ツ)_/¯' | tee /dev/tty | pbcopy
	else
		echo '¯\_(ツ)_/¯'
	fi
}

##
# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
# From https://github.com/mathiasbynens/dotfiles/blob/master/.functions
##
isInstalled tree && tre() {
	tree -aC -I '.git|.next|node_modules|bower_components' --dirsfirst "$@" | less -FRX
}

##
# Add shortcut for starting the Android Emulator with a list of devices
##
isInstalled emulator && android-emulator() {
	local device=$(emulator -list-avds | ipt)
	emulator -avd "${device}" -no-boot-anim -ranchu $@ &
}
