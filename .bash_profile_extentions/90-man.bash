# Add a little color to man
LESS_TERMCAP_mb=$(printf '\e[32m')
LESS_TERMCAP_md=$(printf '\e[32m')
LESS_TERMCAP_me=$(printf '\e[0m')
LESS_TERMCAP_se=$(printf '\e[0m')
LESS_TERMCAP_so=$(printf '\e[1;44;37m')
LESS_TERMCAP_ue=$(printf '\e[0m')
LESS_TERMCAP_us=$(printf '\e[34m')
export LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_se LESS_TERMCAP_so LESS_TERMCAP_ue LESS_TERMCAP_us

notifyLoaded
