# Fun prompt symbols:
# ❯ ▲ ➤ ➥ $
# % ☯︎ ✳︎ ⌘ ⌥
# ⚡︎ ƒ ⍺ ß ⌬

promptCommand() {
	local lastReturn="$?" # Must go first!

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

	__git_ps1 "${symbol} ${directoryColor}\W${repoColor}" "${e_reset} " " %s"
	update_terminal_cwd 2>/dev/null
}

PROMPT_COMMAND='promptCommand'