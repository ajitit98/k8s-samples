import docker

# Create a Docker client from environment (local Docker daemon)
client = docker.from_env()

def start_container(image_name, container_name=None, command=None):
    """
    Pulls an image (if needed) and starts a container.

    :param image_name: Docker image to use (e.g., "nginx:latest")
    :param container_name: Optional name for the container
    :param command: Optional command to run inside container
    """
    print(f"Pulling image {image_name} (if not already present)…")
    client.images.pull(image_name)

    print(f"Starting container from image {image_name}…")
    container = client.containers.run(
        image_name,
        name=container_name,
        command=command,
        detach=True  # Run in background
    )

    print(f"Container started with ID: {container.id}")
    return container

# Example: start an nginx container
start_container("nginx:latest", container_name="my_nginx")
