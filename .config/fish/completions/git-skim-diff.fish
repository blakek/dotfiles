# Add a description for the custom Git subcommand
complete -c git \
    -f \
    -n __fish_git_needs_command \
    -a skim-diff \
    -d 'Show a diff excluding large/ignored files'

# Options
complete -c git \
    -f \
    -n '__fish_git_using_command skim-diff' \
    -s m \
    -l max-size \
    -r \
    -d 'Maximum file size in KB to include in the diff'

complete -c git \
    -f \
    -n '__fish_git_using_command skim-diff' \
    -s h \
    -d 'Show help and exit'

# "help" is also accepted as a positional argument
complete -c git \
    -f \
    -n '__fish_git_using_command skim-diff' \
    -a help \
    -d 'Show help and exit'

# Source and target branches
complete -c git \
    -f \
    -n '__fish_git_using_command skim-diff' \
    -a '(__fish_git_branches)'
