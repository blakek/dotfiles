#!/usr/bin/env bash
set -eu -o pipefail

__dirname="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
installRoot="${HOME}"
isDryRun='false'
shouldForceRun='false'
shouldShowDiff='false'
verbosity=0
versionString='0.1.0'

showHelp() {
	cat <<-EOF
		Usage: ./bootstrap.sh [OPTIONS]

		Examples:
			Install all dotfiles:
			./bootstrap.sh

			Check if any files would be replaced by running this:
			./bootstrap.sh --dry-run

		Options:
			-D, --diff     show the difference in conflicting files
			-d, --dry-run  just show the files that would be copied over
			-f, --force    skip the warnings and go straight to setup
			-h, --help     show this help text
			-v, --verbose  be more verbose
			-V, --version  print script version and exit
	EOF
}

printError() {
	echo 'Error:' "$@" >&2
}

fileIsConflict() {
	src="${__dirname}/$1"
	dest="${installRoot}/$1"

	# Remember, in Bash, 0 is "truthy" and 1 is "falsy"

	# File doesn't exist, so it's not a conflict to add
	if [ ! -e "$dest" ]; then
		return 1
	fi

	# File exists but has the same contents
	if output="$(diff "$src" "$dest")"; then
		return 1
	fi

	# File exists and has different contents
	if $shouldShowDiff; then
		printf '%s < > %s:\n%s' "$src" "$dest" "$output"
	fi

	return 0
}

main() {
	while (($# > 0)); do
		arg="$1"

		case $arg in
			-d | --dry-run) isDryRun='true' ;;
			-D | --diff) shouldShowDiff='true' ;;
			-f | --force) shouldForceRun='true' ;;
			-h | --help)
				showHelp
				exit
				;;
			-v | --verbose) verbosity=1 ;;
			-V | --version)
				echo "${versionString}"
				exit
				;;
			*)
				echo "Error: unrecognized argument '$1'. Use --help to show usage." >&2
				exit 1
				;;
		esac

		shift
	done

	# Stop if expected behavior is unknown
	if $isDryRun && $shouldForceRun; then
		printError '--dry-run and --force cannot be set at the same time'
		exit 1
	fi

	if ((verbosity > 0)); then
		echo "Install root is ${installRoot}"
	fi

	# Make list of files to install
	local files=(
		bin/*
		.bash_*
		'.gitconfig'
		'.gitignore'
		'.tmux.conf'
	)

	local conflicts=()

	if ! $shouldForceRun; then
		# Check for possible conflicts
		for file in "${files[@]}"; do
			if fileIsConflict "$file"; then
				conflicts+=("$file")
			fi
		done

		if ((${#conflicts[@]} > 0)); then
			echo ''
			echo 'CONFLICTING FILES:'
			echo '=================='

			for file in "${conflicts[@]}"; do
				echo "  - $file"
			done

			echo 'Resolve the conflicting files or use --force to overwrite'
			exit 1
		fi
	fi

	# Make necessary directories for install
	mkdir -p "${installRoot}/bin"

	for file in "${files[@]}"; do
		# Dry run just prints files that would be linked
		if $isDryRun; then
			printf 'would link %s => %s\n' "${file}" "${installRoot}/${file}"
			continue
		fi

		# Verbose flag still prints files that are linked
		if ((verbosity > 0)); then
			printf 'linking %s => %s\n' "${file}" "${installRoot}/${file}"
		fi

		ln -sfn "${__dirname}/${file}" "${installRoot}/${file}"
	done
}

main "$@"
