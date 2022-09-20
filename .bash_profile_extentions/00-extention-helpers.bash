#!/usr/bin/env bash

if [[ ${VERBOSITY:-} == '' ]]; then
	notifyLoaded() { return; }
	notifySkipped() { return; }
	notifyWarn() { return; }

	return
fi

notifyLoaded() {
	local moduleName
	moduleName="$(basename "$(caller | awk '{print $2}')" .bash)"
	printf '%b✔%b %s loaded\n' "$green" "$reset" "$moduleName"
}

notifySkipped() {
	local reason="$1"

	local moduleName
	moduleName="$(basename "$(caller | awk '{print $2}')" .bash)"

	if [[ ${reason:-} != '' ]]; then
		printf '%b⚠ %s skipped:%b %s\n' "$yellow" "$moduleName" "$reset" "$reason"
	else
		printf '%b⚠ %s skipped%b\n' "$yellow" "$moduleName" "$reset"
	fi
}

notifyWarn() {
	local message="$1"

	local moduleName
	moduleName="$(basename "$(caller | awk '{print $2}')" .bash)"

	printf '%b⚠ %s warning:%b %s\n' "$yellow" "$moduleName" "$reset" "$message"
}

[[ ${BASH_VERSINFO[0]} -lt 4 ]] && {
	notifyWarn "Bash version is less than 4.0.0. Some features may not work."
}

notifyLoaded
