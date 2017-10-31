prompt() {
  local lastReturn="$?";
  local prompt="${primaryColor}[\W${repoColor}\$(__git_ps1 \" %s\")${primaryColor}]";

  if [ $lastReturn == "0" ]; then
    dolla=$primaryColor"\$";
  else
    dolla=$errorColor"\$";
  fi

  PS1="${prompt}${dolla} ${e_reset}"

  update_terminal_cwd 2>/dev/null
}
