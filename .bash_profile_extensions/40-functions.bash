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
# Shows outdated Homebrew packages that are "leaves" (i.e. not dependencies)
##
brew-leaves-outdated() {
	comm -12 <(brew outdated | sort) <(brew leaves | sort)
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
	projectDirectory=$(ls "$developDirectory" | ipt -M 'Choose a project' -a)
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
# Trashes all node_modules found in a repo
##
trash-node-modules() {
	local repoRoot
	repoRoot="$(git rev-parse --show-toplevel)"

	mapfile -t filesToRemove < <(find "$repoRoot" -type d -name 'node_modules' -prune -print0 | xargs -0 -n 1 realpath)

	if [[ ${#filesToRemove[@]} -eq 0 ]]; then
		echo "No node_modules found in the repository"
		return
	fi

	echo "Found ${#filesToRemove[@]} node_modules directories to remove:"
	for file in "${filesToRemove[@]}"; do
		echo "  - $file"
	done

	read -p "Are you sure you want to remove these directories? [Y/n] " -n 1 -r
	echo

	if [[ -n $REPLY && ! $REPLY =~ ^[Yy]$ ]]; then
		echo "Aborting."
		return
	fi

	local removeCommand="rm -rf"

	# Removing using `trash` can seem _way_ faster than `rm -rf`
	if isInstalled trash; then
		removeCommand="trash"
	fi

	$removeCommand "${filesToRemove[@]}"
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

portForProject() {
	# Get the project root directory from git
	local -r projectRoot="$(git rev-parse --show-toplevel)"

	# Try to get the port from the package.json file
	grep -Eo '[-:=]\d{4}' \
		"${projectRoot}/packages/service/package.json" |
		# Get the first match
		head -n 1 |
		# Remove the leading characters
		sed -E 's/[-:=]//g' || echo 3000
}

projectManagerForProject() {
	# Get the project root directory from git
	local -r projectRoot="$(git rev-parse --show-toplevel)"
	local packageManager=""

	# Try to get the package manager from the `.tool-versions` file
	packageManager="$(grep -Eo 'bun|pnpm|yarn|npm' \
		"${projectRoot}/.tool-versions" |
		# Get the first match
		head -n 1)"

	if [[ $packageManager != "" ]]; then
		echo "$packageManager"
		return
	fi

	# Try to get the package manager from the lock file
	if [[ -f "${projectRoot}/bun.lockb" || -f "${projectRoot}/bun.lock" ]]; then
		packageManager="bun"
	elif [[ -f "${projectRoot}/pnpm-lock.yaml" ]]; then
		packageManager="pnpm"
	elif [[ -f "${projectRoot}/yarn.lock" ]]; then
		packageManager="yarn"
	elif [[ -f "${projectRoot}/package-lock.json" ]]; then
		packageManager="npm"
	fi

	echo "${packageManager:-bun}"
}

##
# Start the dev server along with some helpful extras
##
yeet() {
	local port=""
	local packageManager=""
	port="${PORT:-$(portForProject)}"
	packageManager="$(projectManagerForProject)"

	git pull --prune --quiet
	$packageManager install --silent
	$packageManager run dev --silent &

	waitForPort "$port"
	open "http://localhost:${port}/"

	fg
}

notifyLoaded
