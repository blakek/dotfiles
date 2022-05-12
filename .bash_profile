#!/usr/bin/env bash

# Set `VERBOSITY` to show debug messages in imported scripts
# VERBOSITY="1"

# If a file exists and is not empty, source it. Otherwise, return an falsy value
import() {
	# shellcheck disable=SC1090
	[ -r "$1" ] && source "$1"
}

# Import aliases & functions
import "${HOME}/.bash_functions"
import "${HOME}/.bash_aliases"

# Set global environment variables and secrets
set -o allexport
import "${HOME}/.env"
set +o allexport

declare -ar pathAdditions=(
	# My personal scripts
	"${HOME}/bin"
	# Rust binaries
	"${HOME}/.cargo/bin"
	# Go binaries
	"${HOME}/go/bin"
	# Yarn global commands
	"${HOME}/.yarn/bin"
	"${HOME}/.config/yarn/global/node_modules/.bin"
	# Directory-specific node_modules
	"node_modules/.bin"
)

# I don't know how to use emacs
export EDITOR='vim'
# …but I do want emacs-style line-editing
set -o emacs

# Shell options
#   autocd        `cd` into directories without typing `cd` (Bash 4+)
#   cdspell       `cd` into directories if a minor typo is made
#   histappend    append to - rather than overwriting - history
#   hostcomplete  try completing hostnames when an `@` is found
#   lithist       save long commands in history with newlines (not semicolons)
#   no_empty_cmd_completion    don't try to complete an empty line
shopt -s cdspell histappend hostcomplete lithist no_empty_cmd_completion
[[ ${BASH_VERSINFO[0]} -ge 4 ]] && shopt -s autocd

# Don't remember duplicate commands or commands with a leading space space.
export HISTCONTROL='ignoreboth'

# List of history commands to ignore
export HISTIGNORE='exit'

# Enable colors in macOS cli commands
export CLICOLOR=1

# Expand ! combinations
bind Space:magic-space

# Add a little color to man
LESS_TERMCAP_mb=$(printf '\e[32m')
LESS_TERMCAP_md=$(printf '\e[32m')
LESS_TERMCAP_me=$(printf '\e[0m')
LESS_TERMCAP_se=$(printf '\e[0m')
LESS_TERMCAP_so=$(printf '\e[1;44;37m')
LESS_TERMCAP_ue=$(printf '\e[0m')
LESS_TERMCAP_us=$(printf '\e[34m')
export LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_se LESS_TERMCAP_so LESS_TERMCAP_ue LESS_TERMCAP_us

# Export PATH additions
PATH="$(arrayJoin ':' "${pathAdditions[@]}"):${PATH}"
export PATH

# Allow one-off settings to be set per-machine
# NOTE: `{*,.[!.]*}` matches all files in the current directory and loads hidden files **last**
for file in "${HOME}/.bash_profile_extentions"/{*,.[!.]*}; do
	import "${file}"
done
