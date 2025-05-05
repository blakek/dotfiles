#!/usr/bin/env bash

# Force asdf to be prepended to PATH
export ASDF_FORCE_PREPEND="yes"

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
