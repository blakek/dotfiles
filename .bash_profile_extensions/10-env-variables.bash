#!/usr/bin/env bash

# Defaults
export DEV_ROOT="${HOME}/dev"

# Set global environment variables and secrets
set -o allexport
import "${HOME}/.env"
set +o allexport

notifyLoaded
