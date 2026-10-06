#!/bin/bash
set -e

ARTIFACT_PATH=$1

if [ -z "$ARTIFACT_PATH" ]; then
    echo "Error: No artifact specified for deployment!"
    exit 1
fi

if [ ! -f "$ARTIFACT_PATH" ]; then
    echo "Error: Artifact file $ARTIFACT_PATH does not exist!"
    exit 1
fi

echo "=========================================="
echo "DEPLOYMENT IN PROGRESS"
echo "Deploying Artifact : $ARTIFACT_PATH"
echo "Timestamp         : $(date)"
echo "=========================================="

# Simulate deployment process
echo "Stopping previous application..."
echo "Copying $ARTIFACT_PATH to production server..."
echo "Starting new service..."
echo "Deployment Successful!"