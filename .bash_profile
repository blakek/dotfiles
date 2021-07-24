#!/usr/bin/env bash

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
	# Homebrew Python
	"/usr/local/opt/python/libexec/bin"
	# MySQL client
	"/usr/local/opt/mysql-client/bin"
	# Directory-specific node_modules
	"node_modules/.bin"
)

# Add my personal programs to PATH
export BKLIB="${HOME}/bin/lib"
import "${BKLIB}/mylog.sh"

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

# bash completion
if isInstalled brew; then
	# Use bash-completion@2 if installed; fallback to v1
	if [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]]; then
		export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
		import "$(brew --prefix)/etc/profile.d/bash_completion.sh"
	else
		import "$(brew --prefix)/etc/bash_completion"
	fi
else
	import "${HOME}/.git-completion.bash"
fi

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

# git prompt settings
import "${HOME}/.git-prompt.sh" && {
	export GIT_PS1_SHOWDIRTYSTATE='yes'
	export GIT_PS1_SHOWUNTRACKEDFILES='yes'
	export GIT_PS1_SHOWSTASHSTATE='yes'
	export GIT_PS1_SHOWUPSTREAM='auto'
}

# My prompt
# Symlink a prompt from ./prompts/* to ~/.bash_prompt to get started
source "${HOME}/.bash_prompt" && {
	setPromptCommand
	export primaryColor=${e_white:=}
	export errorColor=${e_light_red:=}
	export secondaryColor=${e_light_cyan:=}
	export repoColor=${e_light_green:=}
}

# Android stuff
if [ -d "${HOME}/Library/Android/sdk" ]; then
	export ANDROID_HOME="${HOME}/Library/Android/sdk"
	export ANDROID_SDK="${ANDROID_HOME}"
	PATH="${PATH}:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools"
fi

PATH="$(arrayJoin ':' "${pathAdditions[@]}"):${PATH}"

export PATH

# Always start on a good note
true
