# NOTE: this needs to come after the PATH additions

if isInstalled brew; then
	brewPrefix="$(brew --prefix)"

	# Use bash-completion@2 if installed; fallback to v1
	if [[ -r "${brewPrefix}/etc/profile.d/bash_completion.sh" ]]; then
		export BASH_COMPLETION_COMPAT_DIR="${brewPrefix}/etc/bash_completion.d"
		import "${brewPrefix}/etc/profile.d/bash_completion.sh"
	else
		import "${brewPrefix}/etc/bash_completion"
	fi

	notifyLoaded
	return
fi

if [[ -r "${HOME}/.git-completion.bash" ]]; then
	notifyWarn 'brew not found; loading ~/.git-completion.bash'
	import "${HOME}/.git-completion.bash"
else
	notifySkipped
fi
