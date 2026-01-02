#!/usr/bin/env bash

##
# Standardize system commands
##
alias l='ls -F'
alias la='ls -A'
alias ll='ls -lhAF'

alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

alias poweroff='shutdown -h now'

##
# Fix common typos
##
alias celar='echo "😜"; sleep .25; clear'
alias sl='echo "🚂  choo-choo"; ls'

##
# Shorthand shortcuts
##

# VS Code
alias c='code'

# git
alias g='git'
alias gaa='git add .'
alias gb='git branch'
alias gc='git checkout'
alias gcm='git checkout master'
alias gcb='git checkout -b'
alias gd='git diff'
alias gdf='git diff'
alias gf='git fetch --prune'
alias gl='git log'
alias glg='git log --graph --decorate --oneline --color | less -R'
alias gp='git pull --prune'
alias gs='git status'

# yarn
alias yy='yarn && yarn dev'
alias yyd='yarn && yarn dev'
alias ytc='yarn && yarn typecheck'
# Faster parallelized "yarn" commands
alias yp="bun run --filter '*'"

# Rsync with defaults to only rely on checksums
alias rcp='rsync --archive --compress --checksum --human-readable --no-times --progress'

##
# Shortcuts to OS X executables
##
alias brave-browser='/Applications/Brave\ Browser.app/Contents/MacOS/Brave\ Browser'
alias chrome-browser='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias firefox='/Applications/Firefox.app/Contents/MacOS/firefox'
alias imageoptim='/Applications/ImageOptim.app/Contents/MacOS/ImageOptim'

# Fix nanocoder wanting to use `node` instead of `bun`
alias nanocoder='bunx --bun @nanocollective/nanocoder nanocoder'

notifyLoaded
