export HOMEBREW_PREFIX=""

if [[ -x "/opt/homebrew/bin/brew" ]]; then
	HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -x "/usr/local/bin/brew" ]]; then
	HOMEBREW_PREFIX="/usr/local"
elif [[ -x "$(type -P brew)" ]]; then
	HOMEBREW_PREFIX="$(brew --prefix)"
else
	notifySkipped 'homebrew directory not found'
	return
fi

export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"
export PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin${PATH+:$PATH}"
export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH:-}"

notifyLoaded
