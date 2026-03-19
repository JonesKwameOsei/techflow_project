#!/bin/bash

# Tag current stable image as previous_stable before new deployment
# This enables rollback functionality

# Check for required environment variables
if [ -z "${DOCKERHUB_USERNAME}" ]; then
    echo "❌ Error: DOCKERHUB_USERNAME environment variable is not set"
    echo "   Please ensure DOCKERHUB_USERNAME is passed from the workflow"
    exit 1
fi

# Use dynamic image name based on repository
REPO_NAME="${REPO_NAME:-techflow_project}"
DOCKER_IMAGE="${DOCKERHUB_USERNAME}/${REPO_NAME}"
CONTAINER_NAME="${CONTAINER_NAME:-techflow-app}"

echo "🏷️ Tagging current stable image as previous_stable..."
echo "📦 Docker image: $DOCKER_IMAGE"
echo "🏷️ Container name: $CONTAINER_NAME"

# Check if container is running
if sudo docker ps --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    # Get current running image ID
    CURRENT_IMAGE=$(sudo docker inspect "$CONTAINER_NAME" --format='{{.Config.Image}}')
    echo "📦 Current running image: $CURRENT_IMAGE"

    # Tag it as previous_stable locally
    if sudo docker tag "$CURRENT_IMAGE" "$DOCKER_IMAGE:previous_stable"; then
        echo "✅ Local tagging successful"
    else
        echo "❌ Failed to tag image locally"
        exit 1
    fi

    # Push the previous_stable tag to DockerHub
    echo "📤 Pushing previous_stable tag to DockerHub..."
    if sudo docker push "$DOCKER_IMAGE:previous_stable"; then
        echo "✅ Previous stable tag pushed successfully"
    else
        echo "❌ Failed to push previous_stable tag"
        exit 1
    fi
else
    echo "⚠️ No running container found. This might be the first deployment."
    echo "   Creating a dummy previous_stable tag using current latest image..."

    # Pull latest and tag as previous_stable for safety
    if sudo docker pull "$DOCKER_IMAGE:latest" && \
       sudo docker tag "$DOCKER_IMAGE:latest" "$DOCKER_IMAGE:previous_stable" && \
       sudo docker push "$DOCKER_IMAGE:previous_stable"; then
        echo "✅ Dummy previous_stable tag created"
    else
        echo "❌ Failed to create dummy previous_stable tag"
        exit 1
    fi
fi

echo "🎯 Tagging complete. Ready for deployment."
