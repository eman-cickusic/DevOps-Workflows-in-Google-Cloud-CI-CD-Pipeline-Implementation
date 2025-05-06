#!/bin/bash
# Script to demonstrate Docker commands for Artifact Registry

# Exit immediately if a command exits with a non-zero status
set -e

# Check if REGION is provided as an argument, otherwise use a default
if [ -z "$1" ]; then
  echo "No region specified, using us-central1 as default."
  REGION="us-central1"
else
  REGION=$1
fi

# Get the current project ID
export PROJECT_ID=$(gcloud config get-value project)

echo "Working with Docker images in project: $PROJECT_ID"
echo "Using region: $REGION"

echo
echo "Step 1: Pulling a sample image from a public repository"
docker pull us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0

echo
echo "Step 2: Tagging the image for your private repository"
docker tag us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0 \
    $REGION-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1

echo
echo "Step 3: Pushing the image to your private repository"
docker push $REGION-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1

echo
echo "Step 4: Pulling the image from your private repository"
docker pull $REGION-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1

echo
echo "All operations completed successfully!"
echo
echo "Image details:"
echo "- Repository: $REGION-docker.pkg.dev/$PROJECT_ID/example-docker-repo"
echo "- Image: sample-image"
echo "- Tag: tag1"
echo
echo "You can run the sample with:"
echo "docker run $REGION-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1"
