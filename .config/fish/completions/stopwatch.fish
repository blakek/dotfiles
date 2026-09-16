# Disable file completions
complete -c stopwatch -f

# Options
complete -c stopwatch -s h -l help -d 'Show help'
complete -c stopwatch -l interval -d 'Set the interval for the stopwatch ticks in milliseconds (default: 100)'
complete -c stopwatch -l no-controls -d 'Disallow keyboard shortcuts for controlling the stopwatch'
complete -c stopwatch -l no-output -d 'Suppress the final output when the stopwatch is stopped'
