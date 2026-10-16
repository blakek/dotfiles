# MR IID or URL is optional; the command defaults to the current branch’s MR.
complete -c glab-watch-ci -f
complete -c glab-watch-ci -s C -l directory -x -a '(__fish_complete_directories)' -d 'Use another local checkout'
complete -c glab-watch-ci -s R -l repo -x -d 'GitLab project path or URL (requires an MR IID)'
complete -c glab-watch-ci -l no-wait -d 'Fetch status once and exit'
complete -c glab-watch-ci -l json -d 'Print the final result as JSON'
complete -c glab-watch-ci -s h -l help -d 'Show help'
