#!/usr/bin/env bash

# Save applications installed with Homebrew
brew bundle dump --all --describe --force

# Save applications installed with npm
npm ls -g --depth=0 --json |
	jq '.dependencies | keys | . - ["npm"]' \
		>npm-global.json
