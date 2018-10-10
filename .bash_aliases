##
# Standarize system commands
##
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -lhF'

alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

alias poweroff='sudo shutdown -h now'
alias reboot='sudo reboot'

##
# Fix common typos
##
alias aotm='atom'
alias celar='echo "😜"; sleep .25; clear'
alias sl='echo "🚂  choo-choo"; ls'

##
# Defaults and alternatives for programs
##
isInstalled ccat && alias cat=ccat
isInstalled bat && alias cat=bat
alias howdoi='how2 -l javascript'
alias shrug='shrug | clipboard'
alias webcoach='webcoach --details --description'

##
# Shorthand shortcuts
##

# brew leaves outdated
alias blo='comm -12 <(brew outdated | sort) <(brew leaves | sort)'

# Browsersync
alias bs='browser-sync start --logLevel silent --server --files .'

# git
alias g='git'
alias gaa='git add .'
alias gb='git branch'
alias gc='git checkout'
alias gcm='git checkout master'
alias gcb='git checkout -b'
alias gd='git diff'
alias gf='git fetch --prune'
alias gl='git log'
alias glg='git log --graph --decorate --oneline --color | less -R'
alias gp='git pull --prune'
alias gs='git status'

function gdf() {
	git diff --color "$@" | diff-so-fancy | less -R
}

alias gh='github'

alias st='subl'

##
# Shortcuts to OS X executables
##
alias altool='/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Support/altool'
alias chrome-browser='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias vscode='/Applications/Visual\ Studio\ Code.app/Contents/MacOS/Electron'
alias firefox='/Applications/FirefoxDeveloperEdition.app/Contents/MacOS/firefox'
alias imageoptim='/Applications/ImageOptim.app/Contents/MacOS/ImageOptim'

##
# Functions
##
function github() {
	github="$(type -fp github)"
	[[ github == '' ]] && echo '`github` is not installed' && return
	[[ $# -eq 0 ]] && "${github}" . || "${github}" "$@"
}

isInstalled ipt && function iseek() {
	cd "$(ls -a -d */ .. | ipt)"
	iseek
}
