#!/usr/bin/env bash

if [[ -r "${HOME}/.bun" ]]; then
	export BUN_INSTALL="$HOME/.bun"
	export PATH="$BUN_INSTALL/bin:${PATH}"
	notifyLoaded
else
	notifySkipped
fi
