update_open_web_ui() {
	echo "Pulling latest Open Web UI Docker image..."
	podman pull ghcr.io/open-webui/open-webui:main

	echo "Stopping and removing existing Open Web UI container (if any)..."
	podman stop open-webui 2>/dev/null || true
	podman rm open-webui 2>/dev/null || true

	echo "Starting new Open Web UI container..."
	podman run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
}

export -f update_open_web_ui
