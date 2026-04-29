#!/usr/bin/env bash

function register_bun() {
	local BUN_INSTALL="$HOME/.bun"

	if [[ ! -r "${BUN_INSTALL}" ]]; then
		notifySkipped
	fi

	export BUN_INSTALL
	export BUN_GLOBAL_BIN="${BUN_INSTALL}/install/global/node_modules/.bin"
	export PATH="${BUN_INSTALL}/bin:${BUN_GLOBAL_BIN}:${PATH}"

	# # Replace Node.js for globally installed packages
	local node_install_path="${BUN_INSTALL}/node_symlink_hack"
	local node_path="${node_install_path}/node"
	local bun_path="${BUN_INSTALL}/bin/bun"

	if [[ ! -L "${node_path}" && -x "${bun_path}" ]]; then
		mkdir -p "${node_install_path}"
		ln -s "${bun_path}" "${node_path}"
	fi

	# Add to the end so that it doesn't interfere with any existing Node.js installation
	PATH="${PATH}:${node_install_path}"

	notifyLoaded
}

register_bun
