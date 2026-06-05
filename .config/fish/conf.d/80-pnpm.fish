# pnpm's default is "${HOME}/Library/pnpm" on macOS
# Change it to be more consistent with other tools
set -xg PNPM_HOME $HOME/.local/share/pnpm

fish_add_path --append $PNPM_HOME
