#!/usr/bin/env bash

load_asdf() {
	local -r asdfPath="${HOME}/.asdf"
	local -r shimPath="${asdfPath}/shims"

	if ! [[ -r ${shimPath} ]]; then
		notifySkipped
		return
	fi

	# Add asdf to the PATH
	export PATH="${PATH}:${shimPath}"
	notifyLoaded
}

load_asdf
