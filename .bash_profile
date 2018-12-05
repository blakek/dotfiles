# If a file exists and is not empty, source it. Otherwise, return an falsy value
import() {
	[ -s "$1" ] && source "$1"
}

# Return truthy/falsy value indicating if every argument is installed
# (i.e. found in hash lookup)
isInstalled() {
	hash "$@" 2> /dev/null
}

# Add my personal programs to PATH
export PATH="${HOME}/bin:${PATH}"
export BKLIB="${HOME}/bin/lib"
import "${BKLIB}/mylog.sh"

# I don't know how to use emacs
export EDITOR='vim'

# shell options
#   autocd        `cd` into directories without typing `cd`
#   cdspell       `cd` into directories if a minor typo is made
#   histappend    append to - rather than overwriting - history
#   hostcomplete  try completing hostnames when an `@` is found
#   lithist       save long commands in history with newlines (not semicolons)
#   no_empty_cmd_completion    don't try to complete an empty line
shopt -s autocd cdspell histappend hostcomplete lithist no_empty_cmd_completion

# Don't remember duplicate commands or commands with a leading space space.
export HISTCONTROL='ignoreboth'

# List of history commands to ignore
export HISTIGNORE='exit'

# My aliases
import "${HOME}/.bash_aliases"

# bash completion
isInstalled brew && import "$(brew --prefix)/etc/bash_completion"

# git bash completion
import "${HOME}/.git-completion.bash"

# Add directory-specific node_modules to PATH
export PATH="node_modules/.bin:${PATH}"

# Enable colors in macOS cli commands
export CLICOLOR=1

# Expand ! combinations
bind Space:magic-space

# Add a little color to man
export LESS_TERMCAP_mb=$(printf '\e[32m')
export LESS_TERMCAP_md=$(printf '\e[32m')
export LESS_TERMCAP_me=$(printf '\e[0m')
export LESS_TERMCAP_se=$(printf '\e[0m')
export LESS_TERMCAP_so=$(printf '\e[1;44;37m')
export LESS_TERMCAP_ue=$(printf '\e[0m')
export LESS_TERMCAP_us=$(printf '\e[34m')

# git prompt settings
import "${HOME}/.git-prompt.sh" && {
	export GIT_PS1_SHOWDIRTYSTATE='yes'
	export GIT_PS1_SHOWUNTRACKEDFILES='yes'
	export GIT_PS1_SHOWSTASHSTATE=''
	export GIT_PS1_SHOWUPSTREAM='auto'
}

# My prompt
source "$HOME/bin/prompts/triangle.sh" && {
	setPromptCommand
	primaryColor=$e_white
	errorColor=$e_light_red
	secondaryColor=$e_light_cyan
	repoColor=$e_light_green
}

# Android stuff
if [ -d "${HOME}/Library/Android/sdk" ]; then
	export ANDROID_HOME="${HOME}/Library/Android/sdk"
	export ANDROID_SDK="${ANDROID_HOME}"
	export PATH="${PATH}:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools"
fi

# Rust stuff
export PATH="$HOME/.cargo/bin:$PATH"

# Always start on a good note
true
