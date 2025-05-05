#!/usr/bin/env bash

declare -a pathAdditions=(
	# My personal scripts
	"${HOME}/bin"
	"${DOTFILES_ROOT}/bin"
	# Rust binaries
	"${HOME}/.cargo/bin"
	# Go binaries
	"${HOME}/go/bin"
	# Yarn global commands
	"${HOME}/.yarn/bin"
	"${HOME}/.config/yarn/global/node_modules/.bin"
	# Deno binaries
	"${HOME}/.deno/bin"
	# Directory-specific node_modules
	"node_modules/.bin"
	# Pipx
	"${HOME}/.local/bin"
)

# Combine all paths into a single string
pathAdditionsString="$(printf '%s:' "${pathAdditions[@]}")"
# Remove trailing colon and prepend to PATH
PATH="${pathAdditionsString%:}:${PATH}"

export PATH

notifyLoaded
