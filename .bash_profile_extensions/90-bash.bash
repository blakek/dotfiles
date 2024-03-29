#!/usr/bin/env bash

# Set Bash options

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

notifyLoaded
