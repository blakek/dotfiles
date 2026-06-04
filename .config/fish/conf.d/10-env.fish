set -l current_file (path resolve (status -f))
set -l current_dir (path dirname "$current_file")
set -l dotfiles_root (path normalize -- "$current_dir/../../..")

# For this dotfiles repo…
set -gx DOTFILES_ROOT "$dotfiles_root"
set -gx DEV_ROOT "$HOME/dev"

# Load ~/.env
if test -f ~/.env
    loadenv ~/.env
end
