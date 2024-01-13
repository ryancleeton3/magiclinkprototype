#!/bin/bash

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "Docker is not running. Please start Docker and retry."
    exit 1
fi

# Pull the Docker Image
if ! docker pull hashicorp/terraform:latest; then
    echo "Failed to pull Terraform Docker image."
    exit 1
fi

# ...

# Run the Docker Container with an overridden entrypoint
if ! docker run -d --name terraform-container --entrypoint sh -v "$(pwd)/terraform:/terraform" hashicorp/terraform:latest -c "while true; do sleep 30; done"; then
    echo "Failed to start the Terraform Docker container."
    exit 1
fi

# Rest of the script...


# Copy Terraform files to the Docker container
if ! docker cp terraform/ terraform-container:/terraform; then
    echo "Failed to copy Terraform files to the container."
    exit 1
fi

# Execute Terraform Init
if ! docker exec -it terraform-container /bin/sh -c "cd /terraform && terraform init"; then
    echo "Terraform init failed."
    exit 1
fi

# Execute Terraform Apply
if ! docker exec -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY terraform-container /bin/sh -c "cd /terraform && terraform apply"; then
    echo "Terraform apply failed."
    exit 1
fi

echo "Terraform execution completed successfully."
