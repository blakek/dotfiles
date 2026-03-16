# Finicky configuration

> This is a configuration file for [Finicky](https://github.com/johnste/finicky), a macOS app that allows you to control which browser to use for different URLs.

Finicky v4 reads TypeScript configs directly, so there is no separate build step for this repo's `finicky.ts`.

## Setup

1. Set up this dotfiles repo
2. Install Finicky; set as the default browser in System Preferences > General > Default web browser
3. Symlink `finicky.ts` to a known Finicky config location (e.g. `~/.finicky.ts`):

```bash
ln -s "${DOTFILES_ROOT}/finicky-config-src/finicky.ts" "${HOME}/.finicky.ts"
```

It should start working.

## Quirks I've noticed

- Named capture groups don't seem to work due to the runtime they chose (https://github.com/johnste/finicky/issues/355). It says it supports them through a Babel transform step, but I couldn't get it to work.
