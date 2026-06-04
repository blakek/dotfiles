#!/usr/bin/env bash

##
# Returns the HTTP status code for a given URL
# Usage: bk.net.httpStatus <url>
##
bk.net.httpStatus() {
	local -r url="${1:?URL is required}"
	curl -s -o /dev/null -w "%{http_code}" "$url"
}

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
# Simple countdown timer
# Usage: countdown <durationInSeconds>
##
countdown() {
	local duration="$1"
	while [[ $duration -gt 0 ]]; do
		printf '\r%ss remaining%b' "$duration" '\033[K'
		sleep 1
		((duration--))
	done
	# Clear the line after finishing
	printf '\r%b' '\033[K'
}

##
# Create a data URL from a file
# From https://github.com/mathiasbynens/dotfiles/blob/master/.functions
# Usage: dataurl <filePath>
##
dataurl() {
	if [[ -z $1 ]]; then
		echo "Missing file path. Usage: dataurl <filePath>" >&2
		return 1
	fi

	local mimeType=$(file -b --mime-type "$1")
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8"
	fi

	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

##
# Downloads audio from a given URL using yt-dlp
# Usage: downloadAudio <url>
##
downloadAudio() {
	yt-dlp --extract-audio --audio-format m4a "$@"
}

##
# Edit stdin payload in $VISUAL/$EDITOR and print the result to stdout
# Usage: editpipe | whatever_command
##
editpipe() (
  set -euo pipefail

  local tmp
  local -a ed
  tmp="$(mktemp "${TMPDIR:-/tmp}/editpipe.XXXXXXXX")"
  trap 'rm -f -- "$tmp"' EXIT INT TERM HUP

  read -r -a ed <<< "${VISUAL:-${EDITOR:-vi}}"
  "${ed[@]}" "$tmp" </dev/tty >/dev/tty

  cat -- "$tmp"
)

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
# Trashes all node_modules found in a repo
# Usage: trash-node-modules
##
trash-node-modules() {
	local repoRoot
	repoRoot="$(git rev-parse --show-toplevel)"

	mapfile -t filesToRemove < <(find """$repoRoot""" -type d -name 'node_modules' -prune -print0 | xargs -0 -n 1 realpath)

	if [[ ${#filesToRemove[@]} -eq 0 ]]; then
		echo "No node_modules found in the repository"
		return
	fi

	echo "Found ${#filesToRemove[@]} node_modules directories to remove:"
	for file in "${filesToRemove[@]}"; do
		echo "  - ""$file"""
	done

	read -p "Are you sure you want to remove these directories? [Y/n] " -n 1 -r
	echo

	if [[ -n $REPLY && ! $REPLY =~ ^[Yy]$ ]]; then
		echo "Aborting."
		return
	fi

	local removeCommand="rm -rf"

	# Removing using $(trash) can seem _way_ faster than $(rm -rf)
	if isInstalled trash; then
		removeCommand="trash"
	fi

	$removeCommand "${filesToRemove[@]}"
}

##
# Prints which process is using the given port
# Usage: whyPortUsed <port>
##
whyPortUsed() {
	local port=""${1?Missing port}""
	# Using $(netstat) instead of $(lsof) because it's faster
	processID=$(
		netstat -van |
			# Find the line with the port
			grep -E "${port}.*LISTEN" |
			# Get the process ID
			awk '{ print $9 }'
	)

	if [[ $processID == '' ]]; then
		echo "Port ""${port}"" doesn't seem to be used"
		return
	fi

	processNameAndArgs=$(ps -p "$processID" -o comm=,args=)

	echo "${processID}: ${processNameAndArgs}"

	# Prompt to kill the process
	read -p "Kill process? [y/N] " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		kill "$processID"
	fi
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
