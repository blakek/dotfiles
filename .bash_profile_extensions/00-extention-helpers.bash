#!/usr/bin/env bash

if [[ ${VERBOSITY-} == '' ]]; then
	notifyLoaded() { return; }
	notifySkipped() { return; }
	notifyWarn() { return; }

	return
fi

_printLoadTime() {
	local startTime="$1"
	local endTime
	endTime=$(msec)

	local loadTime=$((endTime - startTime))

	timeColor="$dim"
	[[ $loadTime -gt 200 ]] && timeColor="$yellow"
	[[ $loadTime -gt 500 ]] && timeColor="$red"

	printf '%b%s%b' \
		"$timeColor" \
		"${loadTime}ms" \
		"$reset"
}

notifyLoaded() {
	local moduleName
	moduleName="$(basename "$(caller | awk '{print $2}')")"
	loadTime="$(_printLoadTime "$DOTFILES_IMPORT_TIME_START")"

	printf '%b✓%b %s loaded %s\n' "$green" "$reset" "$moduleName" "$loadTime"
}

notifySkipped() {
	local reason="$1"

	local moduleName
	moduleName="$(basename "$(caller | awk '{print $2}')")"
	loadTime="$(_printLoadTime "$DOTFILES_IMPORT_TIME_START")"

	if [[ ${reason-} != '' ]]; then
		printf '%b⚠ %s skipped:%b %s %s\n' "$yellow" "$moduleName" "$reset" "$reason" "$loadTime"
	else
		printf '%b⚠ %s skipped%b %s\n' "$yellow" "$moduleName" "$reset" "$loadTime"
	fi
}

notifyWarn() {
	local message="$1"

	local moduleName
	moduleName="$(basename "$(caller | awk '{print $2}')")"

	printf '%b⚠ %s warning:%b %s\n' "$yellow" "$moduleName" "$reset" "$message"
}

[[ ${BASH_VERSINFO[0]} -lt 4 ]] && {
	notifyWarn "Bash version is less than 4.0.0. Some features may not work."
}

notifyLoaded
