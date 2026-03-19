#!/bin/bash

# Health check script for TechFlow application
# Retries up to 5 times to verify the app is healthy

APP_URL="http://localhost:5000/health"
MAX_RETRIES=5
RETRY_DELAY=3

echo "🏥 Starting health check for TechFlow app..."

for ((i=1; i<=MAX_RETRIES; i++)); do
    echo "📞 Health check attempt $i/$MAX_RETRIES..."

    # Make HTTP request and get status code
    HTTP_STATUS=$(curl -s -w "%{http_code}" -o /dev/null "$APP_URL")

    if [ "$HTTP_STATUS" -eq 200 ]; then
        echo "✅ Health check passed! App is healthy (HTTP $HTTP_STATUS)"
        exit 0
    else
        echo "❌ Health check failed. HTTP status: $HTTP_STATUS"
        if [ $i -lt $MAX_RETRIES ]; then
            echo "⏳ Waiting ${RETRY_DELAY}s before retry..."
            sleep $RETRY_DELAY
        fi
    fi
done

echo "💀 Health check failed after $MAX_RETRIES attempts. App is unhealthy."
exit 1
