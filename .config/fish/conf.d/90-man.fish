# Add a little color to man
set -gx LESS_TERMCAP_mb (printf '\e[32m')
set -gx LESS_TERMCAP_md (printf '\e[32m')
set -gx LESS_TERMCAP_me (printf '\e[0m')
set -gx LESS_TERMCAP_se (printf '\e[0m')
set -gx LESS_TERMCAP_so (printf '\e[1;44;37m')
set -gx LESS_TERMCAP_ue (printf '\e[0m')
set -gx LESS_TERMCAP_us (printf '\e[34m')
