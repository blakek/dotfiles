#!/usr/bin/env bash

load_asdf() {
	local -r asdfPath="${HOME}/.asdf"

	if ! [[ -r ${asdfPath} ]]; then
		notifySkipped
		return
	fi

	# Load asdf and its completions
	import "${asdfPath}/asdf.sh"
	import "${asdfPath}/completions/asdf.bash"
	notifyLoaded
}

load_asdf
