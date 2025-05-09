#!/usr/bin/env bash

if [[ -r "${HOME}/.bun" ]]; then
	export BUN_INSTALL="$HOME/.bun"
	export BUN_GLOBAL_BIN="${BUN_INSTALL}/install/global/node_modules/.bin"
	export PATH="${BUN_INSTALL}/bin:${BUN_GLOBAL_BIN}:${PATH}"
	notifyLoaded
else
	notifySkipped
fi
