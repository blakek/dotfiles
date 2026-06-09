#!/usr/bin/env bash

##
# Copies stdin to the clipboard using the first available clipboard utility (clipboard, pbcopy, xclip, wl-copy).
# If no clipboard utility is found, it just prints stdin to stdout.
# Usage: echo "text to copy" | copy [--no-print]
# shellcheck disable=SC2120
##
copy() {
	local -a clip_cmd=()

	for cmd in clipboard pbcopy xclip wl-copy; do
		if isInstalled "$cmd"; then
			case "$cmd" in
				xclip) clip_cmd=(xclip -selection clipboard) ;;
				*) clip_cmd=("$cmd") ;;
			esac
			break
		fi
	done

	if [[ ${#clip_cmd[@]} -eq 0 ]]; then
		cat
		return
	fi

	if [[ $1 == "--no-print" ]]; then
		"${clip_cmd[@]}"
		return
	fi

	tee /dev/tty | "${clip_cmd[@]}"
}

##
# Return truthy/falsy value indicating if every argument is installed
# (i.e. found in hash lookup)
# Usage: isInstalled <command...>
##
isInstalled() {
	hash "$@" 2>/dev/null
}

##
# Test if an element exists in an array.
# Usage: arrayIncludes <arrayName> <searchValue>
##
arrayIncludes() {
	local -n array="$1"
	local search="$2"

	for element in "${array[@]}"; do
		if [[ ${element} == "${search}" ]]; then
			return
		fi
	done

	false
}

##
# Join a bash array using a delimiter (any string)
# Usage: arrayJoin <delimiter> <firstElement> [elements...]
##
arrayJoin() {
	local -r delimiter="$1" firstElement="$2"
	shift 2
	printf '%s' "$firstElement" "${@/#/$delimiter}"
}


##
# Converts HTML to Markdown
# Usage: html2md < input.html > output.md
##
isInstalled pandoc && html2md() {
	pandoc -f html -t gfm-raw_html -
}

##
# Curl + pandoc browser
# Usage: mdbrowser <url>
##
isInstalled html2md glow && mdbrowser() {
	local -r url="$1"
	shift

	curl -Ls "$url" | html2md | glow -p
}

##
# `o` with no arguments opens the current directory, otherwise opens the given
# location
# From https://github.com/mathiasbynens/dotfiles/blob/master/.functions
# Usage: o [fileOrDirectory...]
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
# Usage: p
##
isInstalled gum && p() {
	developDirectory=""${HOME}"/dev"
	projectDirectory=$(ls "$developDirectory" | gum filter --placeholder "Select a project to open...")
	if [[ $projectDirectory != '' ]]; then
		cd """${developDirectory}""/""${projectDirectory}""" && code .
	fi
}

##
# Print ¯\_(ツ)_/¯ and copy to clipboard
# Usage: shrug
##
shrug() {
	echo '¯\_(ツ)_/¯' | copy
}


##
# `tre` is a shorthand for `tree` with sensible defaults
##
isInstalled tree && tre() {
	local command="tree -a --gitignore -I '.git' $*"
	local pager="${PAGER:-less -R}"

	if [[ -t 1 ]]; then
		# Only pipe to pager if output is going to a terminal
		eval "$command" -C | $pager
	fi

	# Otherwise, just run the command
	eval "$command"
}

notifyLoaded
