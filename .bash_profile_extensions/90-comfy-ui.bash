#! /usr/bin/env bash

export PYTORCH_ENABLE_MPS_FALLBACK=1

comfyui_panic() {
  echo "PANIC: $1" >&2
  exit 1
}

comfyui() {
	local resources_path="/Applications/ComfyUI.app/Contents/Resources"
	local main_py_path="$resources_path/ComfyUI/main.py"
	local uv_bin_path="$resources_path/uv/macos/uv"
	local user_base_path="/Users/blakek/Documents/ComfyUI"

	# cd "$resources_path/ComfyUI" || comfyui_panic "Could not change directory to ComfyUI resources"
	cd "$user_base_path" || comfyui_panic "Could not change directory to ComfyUI resources"

	"$uv_bin_path" run "$main_py_path" \
		--user-directory "$user_base_path/user" \
		--input-directory "$user_base_path/input" \
		--output-directory "$user_base_path/output" \
		--front-end-root "$resources_path/ComfyUI/web_custom_versions/desktop_app" \
		--base-directory "$user_base_path" \
		--log-stdout \
		--listen 0.0.0.0 \
		--port 8000 \
		--cpu-vae \
		"$@"
}

export -f comfyui
