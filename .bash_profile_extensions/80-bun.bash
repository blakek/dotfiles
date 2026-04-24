#!/usr/bin/env bash

function register_bun() {
	if [[ ! -r "${HOME}/.bun" ]]; then
		notifySkipped
	fi

	export BUN_INSTALL="$HOME/.bun"
	export BUN_GLOBAL_BIN="${BUN_INSTALL}/install/global/node_modules/.bin"
	export PATH="${BUN_INSTALL}/bin:${BUN_GLOBAL_BIN}:${PATH}"

	# Replace Node.js for globally installed packages
	local node_install_path="${HOME}/.local/bin"
	local node_path="${node_install_path}/node"
	local bun_path="${BUN_INSTALL}/bin/bun"

	if [[ ! -L "${node_path}" && -d "${node_install_path}" && -x "${bun_path}" ]]; then
		ln -s "${bun_path}" "${node_path}"
	fi

	notifyLoaded
}

register_bun
