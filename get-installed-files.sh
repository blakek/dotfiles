#!/usr/bin/env bash

__dirname="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Save applications installed with Homebrew
brew bundle dump --all --describe --force

# Save applications installed with npm
npm ls -g --depth=0 --json |
	fx 'Object.keys(this.dependencies).filter(d => d !== "npm")' \
		>npm-global.json
