#!/usr/bin/env bash

##
# Return truthy/falsy value indicating if every argument is installed
# (i.e. found in hash lookup)
##
isInstalled() {
	hash "$@" 2>/dev/null
}

##
# Test if an element exists in an array.
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
##
arrayJoin() {
	local -r delimiter="$1" firstElement="$2"
	shift 2
	printf '%s' "$firstElement" "${@/#/$delimiter}"
}

##
# Backups up a directory with progress
##
backup() {
	local -a files
	local compressionType="bzip2"

	showUsage() {
		cat <<-END
			Backs up files/directories easily
			Usage:
			    backup [options] <file ...>
			Options:
			    -b, --bzip2    compress files using BZip2 compression (default)
			    -g, --gzip     compress files using GZip compression
			    -h, --help     output usage information and exit
			    -V, --version  output the version number and exit
			Positional arguments:
			    files      list of files/directories to backup
		END
	}

	# Parse arguments
	for arg in "$@"; do
		case "$arg" in
			-b | --bzip | --bzip2)
				compressionType="bzip2"
				;;

			-g | --gzip)
				compressionType="gzip"
				;;

			-h | --help | help)
				showUsage
				return
				;;

			-V | --version)
				echo "1.1.0"
				return
				;;

			-*)
				printf "Error: unrecognized argument '%s'\n" "$arg" >&2
				return 1
				;;

			*) files+=("$arg") ;;
		esac
	done

	for file in "${files[@]}"; do
		directoryName="$(basename "$file")"
		directorySizeKb="$(du -sk "$file" | cut -f1)"
		directorySize="$((directorySizeKb * 1000))"
		parentDirectory="$(dirname "$file")"

		outputName="${directoryName}.tar.bz2"
		[[ $compressionType == "gzip" ]] && outputName="${directoryName}.tar.gz"

		if isInstalled pv; then
			tar -C "$parentDirectory" -cf - "$directoryName" |
				pv -s "$directorySize" |
				$compressionType >"$outputName"
		else
			echo "Note: Install pv to see live progress."
			tar -C "$parentDirectory" -cf "$compressionType" "$directoryName" >"$outputName"
		fi
	done
}

##
# Simple countdown timer
##
countdown() {
	local duration="$1"
	while [[ $duration -gt 0 ]]; do
		printf '\r%ss remaining%b' "$duration" '\033[K'
		sleep 1
		((duration--))
	done
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

dnsinfo() {
	local domain="$1"
	shift

	local -a defaultRecords=('A' 'AAAA' 'CNAME' 'MX' 'SOA' 'TXT')
	local -a recordsRequests=()

	for record in "${@:-"${defaultRecords[@]}"}"; do
		recordsRequests+=("${domain}" "${record}")
	done

	dig +noall +answer +multiline "${recordsRequests[@]}"
}

downloadAudio() {
	yt-dlp --extract-audio --audio-format m4a "$@"
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
# Converts HTML to Markdown
##
html2md() {
	pandoc -f html -t gfm-raw_html -
}

##
# Curl + pandoc browser
##
mdbrowser() {
	local -r url="$1"
	shift

	curl -Ls "$url" | html2md | npx mdless
}

##
# Prints and copies external IP address
##
myip() {
	ip="$(curl --silent api.ipify.org)"

	if isInstalled clipboard; then
		echo "$ip" | tee /dev/tty | clipboard
	elif isInstalled pbcopy; then
		echo "$ip" | tee /dev/tty | pbcopy
	else
		echo "$ip"
	fi
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
# Prints which process is using the given port
##
whyPortUsed() {
	local port="${1?Missing port}"
	# Using `netstat` instead of `lsof` because it's faster
	processID=$(
		netstat -van |
			# Find the line with the port
			grep -E "${port}.*LISTEN" |
			# Get the process ID
			awk '{ print $9 }'
	)

	if [[ $processID == '' ]]; then
		echo "Port ${port} doesn't seem to be used"
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
# Blocks until a port has something listening on it
##
waitForPort() {
	local port="${1?Missing port}"

	# Using `netstat` instead of `lsof` because it's faster
	while ! netstat -van | grep -q "${port}.*LISTEN"; do
		sleep 1
	done
}

##
# Start the dev server along with some helpful extras
##
yeet() {
	# TODO: Add support for different project/port combinations
	local port="${PORT:-9384}"

	git pull --prune --quiet
	yarn install --silent

	yarn dev &

	waitForPort "$port"
	open "http://localhost:${port}/"

	fg
}

notifyLoaded
