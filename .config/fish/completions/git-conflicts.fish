# Add a description for the custom Git subcommand
complete -c git \
    -f \
    -n __fish_git_needs_command \
    -a conflicts \
    -d 'Show conflicts between two branches'

# Options
complete -c git \
    -f \
    -n '__fish_git_using_command conflicts' \
    -s c \
    -l count \
    -d 'Show only a count of conflicting files'

complete -c git \
    -f \
    -n '__fish_git_using_command conflicts' \
    -s h \
    -d 'Show help and exit'

complete -c git \
    -f \
    -n '__fish_git_using_command conflicts' \
    -s v \
    -l version \
    -d 'Show version information and exit'

# "help" is also accepted as a positional argument
complete -c git \
    -f \
    -n '__fish_git_using_command conflicts' \
    -a help \
    -d 'Show help and exit'

# Source and target branches
complete -c git \
    -f \
    -n '__fish_git_using_command conflicts' \
    -a '(__fish_git_branches)'
