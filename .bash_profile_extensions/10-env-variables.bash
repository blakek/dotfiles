#!/usr/bin/env bash

# Set global environment variables and secrets
set -o allexport
import "${HOME}/.env"
set +o allexport

notifyLoaded
