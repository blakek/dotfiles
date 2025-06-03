# Finicky configuration

> This is a configuration file for [Finicky](https://github.com/johnste/finicky), a macOS app that allows you to control which browser to use for different URLs.

## Setup

1. Set up this dotfiles repo
2. Install Finicky; set as the default browser in System Preferences > General > Default web browser
3. Symlink `finicky.ts` to any of the known locations (e.g. `~/.finicky.ts`, `~/.config/finicky/finicky.ts`, etc.)

It should start working.

## Quirks I've noticed

-   Named capture groups don't seem to work due to the runtime they chose (https://github.com/johnste/finicky/issues/355). It says it supports them through a Babel transform step, but I couldn't get it to work.

## `Brewfile`

Many extra tools I use on my daily machines are listed in the `Brewfile` in this directory.

```shell
# Update the Brewfile
brew bundle dump --file Brewfile --force --no-vscode --describe

# Install the tools in the Brewfile
brew bundle --file Brewfile
```
