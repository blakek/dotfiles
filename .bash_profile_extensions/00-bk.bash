#!/usr/bin/env bash

register_bk_lib() {
	# Load bk ANSI/color helpers for interactive shells and other extensions.
	bk_lib="$DOTFILES_ROOT/lib/bk.sh"

	if [[ -r "$bk_lib" ]]; then
		# shellcheck disable=SC1090
		source "$bk_lib"
	fi
}

register_bk_lib
