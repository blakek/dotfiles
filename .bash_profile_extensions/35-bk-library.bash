#!/usr/bin/env bash

bk.net.averagePing() {
	local -r host="${1:?Host is required}"
	local -r count="${2:-5}"
	local -r osType="$(bk.os.type)"

	if [[ $osType == "macos" ]]; then
		ping -c "$count" -i 0.5 "$host" | awk -F '/' '/round-trip/ {print $5}'
	elif [[ $osType == "linux" ]]; then
		ping -c "$count" -i 0.5 "$host" | awk -F '/' '/rtt/ {print $5}'
	else
		echo "Unknown OS type: $osType"
	fi
}

bk.net.httpStatus() {
	local -r url="${1:?URL is required}"
	curl -s -o /dev/null -w "%{http_code}" "$url"
}

bk.os.type() {
	local -r os="$(uname -s)"

	case "$os" in
		Darwin*) echo 'macos' ;;
		Linux*) echo 'linux' ;;
		*) echo "unknown" ;;
	esac
}
