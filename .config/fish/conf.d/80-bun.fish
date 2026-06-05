set -gx BUN_INSTALL "$HOME/.bun"
test -d "$BUN_INSTALL"; or return 0

set -gx BUN_GLOBAL_BIN "$BUN_INSTALL/install/global/node_modules/.bin"
fish_add_path --prepend "$BUN_INSTALL/bin" "$BUN_GLOBAL_BIN"

# Replace Node.js with Bun for globally installed packages
set -l node_shim_dir "$BUN_INSTALL/node-shim"
set -l node_shim "$node_shim_dir/node"
set -l bun_bin "$BUN_INSTALL/bin/bun"

if test ! -L "$node_shim"; and test -x "$bun_bin"
    mkdir -p "$node_shim_dir"
    ln -s "$bun_bin" "$node_shim"
end

fish_add_path --append "$node_shim_dir"
