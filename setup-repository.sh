#!/bin/bash
# Script to create a Docker repository in Google Cloud Artifact Registry

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

echo "Creating Docker repository in project: $PROJECT_ID"
echo "Using region: $REGION"

# Create the Docker repository
gcloud artifacts repositories create example-docker-repo \
    --repository-format=docker \
    --location=$REGION \
    --description="Docker repository" \
    --project=$PROJECT_ID

echo "Repository created successfully."

# Verify repository creation
echo "Listing repositories in project:"
gcloud artifacts repositories list --project=$PROJECT_ID

echo
echo "You can also verify the repository creation in the Google Cloud Console:"
echo "1. Go to the Google Cloud Console: https://console.cloud.google.com"
echo "2. Search for 'Artifact Registry' in the search bar"
echo "3. Check if 'example-docker-repo' is listed in the repositories"
