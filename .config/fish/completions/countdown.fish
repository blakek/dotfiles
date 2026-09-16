# Disable file completions
complete -c countdown -f

# Help option
complete -c countdown -s h -l help -d 'Show help'

# Common countdown durations
complete -c countdown -a 30 -d '30 seconds'
complete -c countdown -a 60 -d '1 minute'
complete -c countdown -a 300 -d '5 minutes'
complete -c countdown -a 900 -d '15 minutes'
complete -c countdown -a 1800 -d '30 minutes'
complete -c countdown -a 3600 -d '1 hour'
