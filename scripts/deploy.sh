#!/bin/bash

# Main deployment script for TechFlow application
# Handles the complete deployment workflow with rollback on failure

set -e  # Exit on any error

DOCKER_IMAGE="${DOCKERHUB_USERNAME}/techflow-app"
CONTAINER_NAME="techflow-app"

echo "🚀 Starting TechFlow deployment..."

# Step 1: Tag current stable version (for rollback capability)
echo "📋 Step 1: Tagging current stable version..."
if ./tag_stable.sh; then
    echo "✅ Current version tagged as previous_stable"
else
    echo "⚠️ Warning: Failed to tag previous stable (continuing anyway)"
fi

# Step 2: Pull latest image
echo "📋 Step 2: Pulling latest image..."
if sudo docker pull "$DOCKER_IMAGE:latest"; then
    echo "✅ Latest image pulled successfully"
else
    echo "❌ Failed to pull latest image"
    exit 1
fi

# Step 3: Stop and remove old container
echo "📋 Step 3: Stopping old container..."
sudo docker stop "$CONTAINER_NAME" 2>/dev/null || true
sudo docker rm "$CONTAINER_NAME" 2>/dev/null || true
echo "✅ Old container removed"

# Step 4: Start new container
echo "📋 Step 4: Starting new container..."
if sudo docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    -p 80:5000 \
    "$DOCKER_IMAGE:latest"; then
    echo "✅ New container started successfully"
else
    echo "❌ Failed to start new container"
    echo "🔄 Initiating rollback..."
    if ./rollback.sh; then
        echo "✅ Rollback completed successfully"
    else
        echo "💀 Rollback failed! Manual intervention required!"
    fi
    exit 1
fi

# Step 5: Health check
echo "📋 Step 5: Running health check..."
sleep 5  # Give container time to initialize

if ./health_check.sh; then
    echo "🎉 Deployment successful! Application is healthy and running."
    exit 0
else
    echo "❌ Health check failed! Initiating rollback..."
    if ./rollback.sh; then
        echo "✅ Rollback completed successfully"
        exit 1
    else
        echo "💀 Rollback failed! Manual intervention required!"
        exit 1
    fi
fi
