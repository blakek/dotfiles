complete -c fancy_timer -f
complete -c fancy_timer -s h -l help -d "output usage information and exit"
complete -c fancy_timer -s v -l version -d "output the version number and exit"
complete -c fancy_timer -s c -l color -r -d "what color to use for the progress bar"
complete -c fancy_timer -s m -l message -r -d "a template message to display"
complete -c fancy_timer -s s -l sleep -r -d "how long to sleep between updates"
complete -c fancy_timer -l no-color -d "disable color output"
complete -c fancy_timer -l no-progress -d "disable the progress bar"
