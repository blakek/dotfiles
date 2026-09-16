# Add a description for the custom Git subcommand
complete -c git \
    -f \
    -n __fish_git_needs_command \
    -a squash \
    -d 'Squashes an entire branch into a single commit'

# Options
complete -c git \
    -f \
    -n '__fish_git_using_command squash' \
    -s m \
    -l message \
    -r \
    -d 'Commit message for the squashed commit'

complete -c git \
    -f \
    -n '__fish_git_using_command squash' \
    -s h \
    -d 'Show help and exit'

# "help" is also accepted as a positional argument
complete -c git \
    -f \
    -n '__fish_git_using_command squash' \
    -a help \
    -d 'Show help and exit'

# Source branch
complete -c git \
    -f \
    -n '__fish_git_using_command squash' \
    -a '(__fish_git_branches)'
