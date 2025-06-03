# `blakek/dotfiles`

This repository contains personal configuration files (dotfiles) and scripts to set up a development environment on macOS and Linux machines. It includes settings and helpers for:

-   Shell (Bash v5+)
-   Git
-   tmux
-   Finicky (browser routing mainly used to skip opening a browser for some apps)
-   Rectangle (window management)
-   Various utility scripts and helpers

It also can optionally install macOS apps to get started using Homebrew / mas.

## Prerequisites

-   Git
-   Bash (v5+ recommended)
-   [Homebrew](https://brew.sh/) (for macOS) or your preferred Linux package manager.
-   [Node.js](https://nodejs.org/) (optional, for npm packages and Finicky config).

## Getting Started

1. Clone the repository:

```bash
git clone <repository-url> dotfiles
cd dotfiles
```

2. Bootstrap your home directory by symlinking configuration files:

```bash
./bootstrap.bash
```

-   Use `--dry-run` to preview which files would be linked.
-   Use `--diff` to show differences in conflicting files.
-   Use `--force` to overwrite existing files without prompt.

## macOS-specific Setup

### Homebrew

[Install Homebrew](https://brew.sh/) to get started.

Then, you can either install the packages and casks listed in the `Brewfile` or use it as a reference for your own setup.

```bash
brew bundle --file Brewfile
```

### Brewfile

The `Brewfile` lists all Homebrew packages and casks.

To update it after installing or removing packages:

```bash
# Using `--no-vscode` to exclude VS Code extensions since they are synced through VS Code settings sync and managed in profiles.
brew bundle dump --file Brewfile --force --no-vscode --describe
```

You can then install the listed packages later. Note, I'd recommend reviewing the `Brewfile` to see what's installed before running the command below, as it will install everything listed in the `Brewfile`.

```bash
brew bundle --file Brewfile
```

### Finicky (optional)

This repo includes a [Finicky](https://github.com/johnste/finicky) configuration to customize browser routing.

You can find the details in the [`finicky-config-src/README.md`](finicky-config-src/README.md) file, but the basic steps are:

```bash
# Install Finicky using Homebrew if you haven't already
brew install --cask finicky
# Open System Preferences > General > Default web browser > Finicky
# Symlink the Finicky config file
ln -s /path/to/dotfiles/finicky-config-src/finicky.ts ~/.finicky.ts
```

### Rectangle

Import the `settings/RectangleConfig.json` file in the [Rectangle](https://rectangleapp.com/) app to apply window management shortcuts.

## Utilities & Maintenance

-   `get-installed-files.sh`: Regenerate `Brewfile` and `npm-global.json` based on your current environment.
-   `bin/`: Custom helper scripts (e.g., `git-skim-diff`, `git-squash`).
-   `helpers/msec`: Timing helper for benchmark scripts.

After adding or removing tools:

```bash
./get-installed-files.sh
git add Brewfile npm-global.json
git commit -m "Update installed packages lists"
```

## Contributing

Pull requests and issues are welcome. I appreciate any contributions to improve this setup.

## Bash Profile + Extensions

If you look, you may notice the [`.bashrc`](.bashrc) file is short (<25 lines). This is because extensions are loaded from the `.bash_profile_extensions` directory. They are loaded in alphanumeric order, so you can control the order of execution by naming the files accordingly (e.g., `01-my-extension.bash`, is loaded before `02-another-extension.bash`). Since this is just the Bash `source` command, any functions or variables defined in previous files will be available in the new file.

You can add your own extensions by creating a new file in `.bash_profile_extensions/`. You can track them in this repo _or_ keep them private by prefixing the filename with a dot (e.g., `.my-extension.bash`). Note, the leading dot will not disrupt the loading order (e.g. `.03-my-private-extension.bash` will still be loaded after `02-another-extension.bash` and before `04-next-extension.bash`).

## Troubleshooting

If you run into issues:

-   Build the `msec` helper script in the `helpers/msec` directory
    -   This is technically optional but useful. You could alternatively comment out the line in `.bashrc` that uses it for timing.
    -   It's a C program that just prints an accurate time. It shows how long it took to source a file and is useful if your prompt takes a while to load.
-   Uncomment `VERBOSITY=1` in `.bashrc` to enable verbose output during sourcing. This uses the `msec` helper + adds allows some extra debug output to help identify issues.
    -   If you write your own extensions, you may use `notifyLoaded`, `notifySkipped`, and `notifyWarn` functions to log messages during sourcing. These automatically use the `msec` helper to show how long it took to load the file + can be helpful if your extension needs to conditionally load (`notifySkipped`) or warn about something unexpected (`notifyWarn`).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
