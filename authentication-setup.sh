#!/bin/bash
# Script to configure authentication for Artifact Registry

# Exit immediately if a command exits with a non-zero status
set -e

# Check if REGION is provided as an argument, otherwise use a default
if [ -z "$1" ]; then
  echo "No region specified, using us-central1 as default."
  REGION="us-central1"
else
  REGION=$1
fi

echo "Configuring Docker authentication for Artifact Registry in region: $REGION"

# Configure Docker to use the gcloud command-line tool as a credential helper
gcloud auth configure-docker $REGION-docker.pkg.dev

echo
echo "Authentication configuration completed!"
echo "You can now push and pull images from your Artifact Registry repositories in $REGION."
echo
echo "Note: This configuration has been added to your Docker configuration file."
echo "For more information about authentication methods, see: https://cloud.google.com/artifact-registry/docs/docker/authentication"
