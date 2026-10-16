# MR IID or URL is optional; the command defaults to the current branch’s MR.
complete -c greptile-list -f
complete -c greptile-list -s C -l directory -x -a '(__fish_complete_directories)' -d 'Use another local checkout'
complete -c greptile-list -s R -l repo -x -d 'GitLab project path or URL (requires an MR IID)'
complete -c greptile-list -l no-wait -d 'Fetch status once and exit'
complete -c greptile-list -l json -d 'Print the final result as JSON'
complete -c greptile-list -s h -l help -d 'Show help'
