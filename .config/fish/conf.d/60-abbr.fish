# Standardize system commands
abbr -a l 'ls -F'
abbr -a la 'ls -A'
abbr -a ll 'ls -lhAF'
abbr -a grep 'grep --colour=auto'
abbr -a poweroff 'shutdown -h now'

# Fix common typos
abbr -a celar 'clear'
abbr -a sl 'ls'

# VS Code
abbr -a c 'code'

# macOS `open`
abbr -a o 'open .'

# git
abbr -a g 'git'
abbr -a gdf 'git diff'
abbr -a gf 'git fetch --prune'
abbr -a gl 'git log'
abbr -a glg 'git log --graph --decorate --oneline --color | less -R'
abbr -a gp 'git pull --prune'
abbr -a gs 'git status --short --branch'

# Podman/Docker compatibility
if ! is-installed docker && is-installed podman; then
	abbr -a docker 'podman'
end

# Rsync with defaults to only rely on checksums
abbr -a rcp 'rsync --archive --compress --checksum --human-readable --no-times --progress'
