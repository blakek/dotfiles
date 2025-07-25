#!/usr/bin/env bash

__DOTFILES_PROMPT_ADDITIONS=()

_printLoadTime() {
	local startTime="$1"
	local endTime
	endTime=$(msec)

	local loadTime=$((endTime - startTime))

	timeColor="dim"
	[[ $loadTime -gt 200 ]] && timeColor="yellow"
	[[ $loadTime -gt 500 ]] && timeColor="red"

	bk.term.decorate "%{${timeColor}}${loadTime}ms%{reset}"
}

registerPromptCommand() {
	local command="$1"

	if [[ -z $command ]]; then
		return
	fi

	__DOTFILES_PROMPT_ADDITIONS+=("$command")
}

notifyInfo() {
	local message="$1"
	local moduleName
	moduleName="$(basename "$(caller | awk '{print $2}')")"

	bk.term.decorate "%{dim}ℹ ${moduleName} info: ${message}%{reset}\n"
}

notifyLoaded() {
	local moduleName
	moduleName="$(basename "$(caller | awk '{print $2}')")"
	loadTime="$(_printLoadTime "$DOTFILES_IMPORT_TIME_START")"

	bk.term.decorate "%{green}✓%{reset} ${moduleName} loaded ${loadTime}\n"
}

notifySkipped() {
	local reason="$1"

	local moduleName
	moduleName="$(basename "$(caller | awk '{print $2}')")"
	loadTime="$(_printLoadTime "$DOTFILES_IMPORT_TIME_START")"

	if [[ ${reason-} != '' ]]; then
		bk.term.decorate "%{yellow}⊘%{reset} ${moduleName} skipped: ${reason} ${loadTime}\n"
	else
		bk.term.decorate "%{yellow}⊘%{reset} ${moduleName} skipped ${loadTime}\n"
	fi
}

notifyWarn() {
	local message="$1"

	local moduleName
	moduleName="$(basename "$(caller | awk '{print $2}')")"

	bk.term.decorate "%{yellow}⚠%{reset} ${moduleName} warning: ${message}\n"
}

[[ ${BASH_VERSINFO[0]} -lt 4 ]] && {
	notifyWarn "Bash version is less than 4.0.0. Some features may not work."
}

if [[ ${VERBOSITY-} == '' ]]; then
	notifyInfo() { return; }
	notifyLoaded() { return; }
	notifySkipped() { return; }

	return
fi

notifyLoaded
