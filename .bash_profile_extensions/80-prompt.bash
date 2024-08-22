# Fun prompt symbols:
# ❯ ▲ ➤ ➥ $ %
# ☯︎ ✳︎ ⌘ ⌥ ﹠
# ⚡︎ ƒ ⍺ ß ⌬

if ! import "${HOME}/.git-prompt.sh"; then
	notifySkipped "${HOME}/.git-prompt.sh not found"
	return
fi

if ! isInstalled realpath; then
	notifyWarn "realpath is not installed"
fi

# git prompt settings
export GIT_PS1_SHOWDIRTYSTATE='yes'
export GIT_PS1_SHOWUNTRACKEDFILES='yes'
export GIT_PS1_SHOWSTASHSTATE='yes'
export GIT_PS1_SHOWUPSTREAM='auto'

promptCommand() {
	local lastReturn="$?" # Must go first!

	# HACK: VSCode takes over `$?`. Use their saved status code instead.
	if [[ $TERM_PROGRAM == "vscode" ]]; then
		lastReturn="${__vsc_status:-0}"
	fi

	local directoryColor="${PS1_DIRECTORY_COLOR:-$e_light_cyan}"

	local repoColor="${PS1_REPO_COLOR:-$e_light_green}"

	local symbolOkColor="${PS1_SYMBOL_OK_COLOR:-$e_reset}"
	local symbolErrorColor="${PS1_SYMBOL_ERROR_COLOR:-$e_red}"
	local symbolOk="${PS1_SYMBOL_OK:-▲}"
	local symbolError="${PS1_SYMBOL_ERROR:-$symbolOk}"
	local symbol

	if ((lastReturn == 0)); then
		symbol="${symbolOkColor}${symbolOk}${e_reset}"
	else
		symbol="${symbolErrorColor}${symbolError}${e_reset}"
	fi

	local isInGitRepo=$(git rev-parse --is-inside-work-tree 2>/dev/null)
	local directory=""
	# Get the "real" path by resolving symlinks
	local cwd="$(pwd -P)"

	# In a git repo, show the CWD relative to the repo root
	# If not in a git repo, show the directory name
	# Examples:
	#   ~/dev/dotfiles (repo root) -> dotfiles
	#   ~/dev/dotfiles/src (repo) -> dotfiles/src
	#   ~/dev/dotfiles/src (not in repo) -> ~/dev/dotfiles/src
	#   /Users/username (home) -> ~
	if [[ $isInGitRepo == "true" ]]; then
		local repoRoot=$(git rev-parse --show-toplevel)
		local repoRootName=$(basename "$repoRoot")

		directory="${cwd/#$repoRoot/$repoRootName}"
	else
		directory="\w"
	fi

	__git_ps1 "${symbol} ${directoryColor}${directory}${repoColor}" "${e_reset} " " %s"
	update_terminal_cwd 2>/dev/null
}

PROMPT_COMMAND='promptCommand'

# import "${HOME}/dev/dotfiles/wip-prompt.bash"

notifyLoaded
