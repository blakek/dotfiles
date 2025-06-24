#!/usr/bin/env bash

# Helper to install all asdf plugins found in a .tool-versions file
asdf-install-plugins() {
	local repoRoot
	repoRoot="$(git rev-parse --show-toplevel 2>/dev/null)"

	if [[ -z $repoRoot ]]; then
		echo "Not in a git repository, skipping asdf plugin installation."
		return 0
	fi

	local toolVersionsFile="${repoRoot}/.tool-versions"

	if [[ ! -f $toolVersionsFile ]]; then
		echo "No .tool-versions file found, skipping asdf plugin installation."
		return 0
	fi

	# Read the .tool-versions file and install plugins
	mapfile -t lines <"$toolVersionsFile"

	for line in "${lines[@]}"; do
		# Skip comments and empty lines
		if [[ -z $line || $line =~ ^\s*# ]]; then
			continue
		fi

		local plugin="${line%% *}"
		asdf plugin add "$plugin"
	done

	asdf install
}

load_asdf() {
	local -r asdfPath="${HOME}/.asdf"
	local -r shimPath="${asdfPath}/shims"

	if ! [[ -r ${shimPath} ]]; then
		unset -f asdf-install-plugins
		notifySkipped
		return
	fi

	# Add asdf to the PATH
	export PATH="${PATH}:${shimPath}"
	registerPromptCommand asdf_on_prompt

	notifyLoaded
}

__asdf_last_install_time=""

asdf_on_prompt() {
	local isInGitRepo
	isInGitRepo=$(git rev-parse --is-inside-work-tree 2>/dev/null)

	if [[ $isInGitRepo != "true" ]]; then
		return
	fi

	local repoRoot
	repoRoot=$(git rev-parse --show-toplevel)
	local toolVersionsFile="${repoRoot}/.tool-versions"
	if [[ ! -f $toolVersionsFile ]]; then
		return
	fi

	local lastToolUpdateTime
	# Stat that works with both macOS and Linux
	lastToolUpdateTime=$(stat --format="%Y" "$toolVersionsFile" 2>/dev/null || stat -f "%m" "$toolVersionsFile" 2>/dev/null)

	if [[ -z $lastToolUpdateTime ]]; then
		return
	fi

	if [[ $lastToolUpdateTime == "$__asdf_last_install_time" ]]; then
		return
	fi

	notifyInfo "Installing asdf plugins from .tool-versions..."
	asdf-install-plugins 2>/dev/null
	__asdf_last_install_time="$lastToolUpdateTime"
}

load_asdf
