#!/bin/bash

# Rollback script for TechFlow application
# Reverts to previous stable version if deployment fails

DOCKER_IMAGE="${DOCKERHUB_USERNAME}/techflow-app"
CONTAINER_NAME="techflow-app"
PREVIOUS_STABLE_TAG="previous_stable"

echo "🔄 Starting rollback process..."

# Stop and remove the broken container
echo "⛔ Stopping and removing broken container..."
sudo docker stop "$CONTAINER_NAME" 2>/dev/null || true
sudo docker rm "$CONTAINER_NAME" 2>/dev/null || true

# Pull the previous stable image
echo "📥 Pulling previous stable image..."
if sudo docker pull "$DOCKER_IMAGE:$PREVIOUS_STABLE_TAG"; then
    echo "✅ Previous stable image pulled successfully"
else
    echo "❌ Failed to pull previous stable image"
    exit 1
fi

# Start the previous stable container
echo "🚀 Starting previous stable container..."
if sudo docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    -p 80:5000 \
    "$DOCKER_IMAGE:$PREVIOUS_STABLE_TAG"; then
    echo "✅ Previous stable container started successfully"
else
    echo "❌ Failed to start previous stable container"
    exit 1
fi

# Wait a moment for container to initialize
sleep 5

# Verify rollback worked
echo "🏥 Verifying rollback..."
if ./health_check.sh; then
    echo "✅ Rollback successful! Previous stable version is running."
    exit 0
else
    echo "❌ Rollback verification failed!"
    exit 1
fi
