# Complete both the standalone command and its glab alias.
complete -c glab -n __fish_use_subcommand -f -a greptile-list -d 'Wait for a Greptile review (defaults to current MR)'

for command in greptile-list glab
    set -l condition true
    if test $command = glab
        set condition 'contains -- greptile-list (commandline -opc)[2]'
    end

    complete -c $command -n $condition -f
    complete -c $command -n $condition -s C -l directory -x -a '(__fish_complete_directories)' -d 'Use another local checkout'
    complete -c $command -n $condition -s R -l repo -x -d 'GitLab project path or URL (requires an MR IID)'
    complete -c $command -n $condition -l no-wait -d 'Fetch status once and exit'
    complete -c $command -n $condition -l json -d 'Print the final result as JSON'
    complete -c $command -n $condition -s h -l help -d 'Show help'
end
