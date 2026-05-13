#!/bin/bash
echo "Starting deployment..."

echo "Building the image for the release status dashboard"
docker build -t release-dashboard:latest .

echo "Testing the image for the release status dashboard"
# Start container
docker run -d -p 3000:3000 --name test-container release-dashboard:latest

# Wait for app to start
sleep 5

# Test it responds
if curl --fail --silent http://localhost:3000/ > /dev/null 2>&1; then
    echo "Container test passed"
else
    echo "Container test failed"
    docker logs test-container
    docker stop test-container
    docker rm test-container
    exit 1
fi

# Cleanup
docker stop test-container
docker rm test-container

echo "Deploying Release Status Dashboard to production..."
docker tag release-dashboard:latest release-dashboard:production
sleep 2

echo "Deployment complete"