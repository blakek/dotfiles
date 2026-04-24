# NOTE: this needs to come after the PATH additions

# With `BASH_COMPLETION_COMPAT_DIR` set, you can add new completions like this:
# <some_command> completion bash > "${BASH_COMPLETION_COMPAT_DIR}/<some_command>"

__register_bash_completion() {
	if isInstalled brew; then
		local brewPrefix
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
		return
	fi

	notifySkipped
}


__register_bash_completion
