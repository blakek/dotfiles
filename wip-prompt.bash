# See parsing work started in `~/dev/git-status-test/`

promptCommand() {
	# Must go first!
	local lastReturn="$?"

	local branchColor="${PS1_BRANCH_COLOR:-$e_green}"

	local branchName
	branchName="$(git symbolic-ref HEAD 2>/dev/null)"
	branchName="${branchName##refs/heads/}"

	local directoryColor="${PS1_DIRECTORY_COLOR:-$e_reset}"

	local symbolOkColor="${PS1_SYMBOL_OK_COLOR:-$e_reset}"
	local symbolErrorColor="${PS1_SYMBOL_ERROR_COLOR:-$e_red}"
	local symbolOk="${PS1_SYMBOL_OK:-\$}"
	local symbolError="${PS1_SYMBOL_ERROR:-$symbolOk}"
	local symbol

	if ((lastReturn == 0)); then
		symbol="${symbolOkColor}${symbolOk}${e_reset}"
	else
		symbol="${symbolErrorColor}${symbolError}${e_reset}"
	fi

	PS1="${symbol} ${directoryColor}\W${e_reset} ${branchColor}${branchName}${e_reset} "
}

PROMPT_COMMAND='promptCommand'
