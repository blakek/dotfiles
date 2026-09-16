# Disable file completions
complete -c wait-for-port -f

# Options
complete -c wait-for-port -s h -l help -d 'Show help'
complete -c wait-for-port -s t -l timeout -r -d 'Maximum time to wait in seconds'
