#!/usr/bin/env bash

# default is "${HOME}/Library/pnpm"
export PNPM_HOME="${HOME}/.config/pnpm"
export PATH="${PATH}:${PNPM_HOME}"
notifyLoaded
