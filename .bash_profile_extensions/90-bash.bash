#!/usr/bin/env bash

# Set Bash options

# I don't know how to use emacs
export EDITOR='vim'
# …but I do want emacs-style line-editing
set -o emacs

# Shell options
#   histappend    append to - rather than overwriting - history
#   hostcomplete  try completing hostnames when an `@` is found
#   lithist       save long commands in history with newlines (not semicolons)
#   no_empty_cmd_completion    don't try to complete an empty line
shopt -s histappend hostcomplete lithist no_empty_cmd_completion

# Don't remember duplicate commands or commands with a leading space space.
export HISTCONTROL='ignoreboth'

# List of history commands to ignore
export HISTIGNORE='exit'

# Enable colors in macOS cli commands
export CLICOLOR=1

# Expand ! combinations
bind Space:magic-space

# Tab through possible completions
bind TAB:menu-complete
bind '\e[Z':menu-complete-backward # Shift+Tab

# Show the completion list. The default is tab-completion hides the list.
bind 'set show-all-if-ambiguous on'

# Show some colors in completions
bind 'set colored-stats on'

# Tab-completing in the middle of a word doesn't duplicate what's after the cursor
bind 'set skip-completed-text on'

notifyLoaded
