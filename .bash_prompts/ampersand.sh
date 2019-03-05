getSymbol() {
	declare lastReturn="$1"

	if [ $lastReturn == "0" ]; then
		echo "${primaryColor}${e_bold}﹠${e_reset}"
	else
		echo $errorColor"﹠"
	fi
}

setPS1() {
	local lastReturn="$?"
	local symbol=$(getSymbol $lastReturn)

	PS1="${symbol}${secondaryColor}\W${repoColor}\$(__git_ps1 \" %s\")${e_reset} "

	update_terminal_cwd 2>/dev/null
}

promptCommand() {
	local lastReturn="$?"
	local symbol=$(getSymbol $lastReturn)

	__git_ps1 "${symbol}${secondaryColor}\W${repoColor}" "${e_reset} " " %s"

	update_terminal_cwd 2>/dev/null
}

setPromptCommand() {
	PROMPT_COMMAND='promptCommand'
}
