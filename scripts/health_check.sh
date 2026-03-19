#!/bin/bash

# Health check script for TechFlow application
# Retries up to 5 times to verify the app is healthy
#
# NOTE: Container exposes port 5000 internally but is mapped to port 80 on host
# So this script checks port 80 (or custom via HEALTH_CHECK_URL env var)

# Configurable health check URL (defaults to port 80 since container exposes 80:5000)
APP_URL="${HEALTH_CHECK_URL:-http://localhost/health}"
MAX_RETRIES="${MAX_RETRIES:-5}"
RETRY_DELAY="${RETRY_DELAY:-3}"

echo "🏥 Starting health check for TechFlow app..."
echo "🌐 Health check URL: $APP_URL"

for ((i=1; i<=MAX_RETRIES; i++)); do
    echo "📞 Health check attempt $i/$MAX_RETRIES..."

    # Make HTTP request and get status code
    HTTP_STATUS=$(curl -s -w "%{http_code}" -o /dev/null "$APP_URL")

    if [ "$HTTP_STATUS" -eq 200 ]; then
        echo "✅ Health check passed! App is healthy (HTTP $HTTP_STATUS)"
        exit 0
    else
        echo "❌ Health check failed. HTTP status: $HTTP_STATUS"
        if [ "$i" -lt "$MAX_RETRIES" ]; then
            echo "⏳ Waiting ${RETRY_DELAY}s before retry..."
            sleep "$RETRY_DELAY"
        fi
    fi
done

echo "💀 Health check failed after $MAX_RETRIES attempts. App is unhealthy."
exit 1
