# GitHub Repository Setup Guide

This guide provides step-by-step instructions for setting up the GitHub repository for the DevOps workflows project.

## 1. Create the GitHub Repository

1. Navigate to GitHub and log in to your account
2. Click on the "+" icon in the top right corner and select "New repository"
3. Name your repository "sample-app"
4. Make it public
5. Do not initialize it with any files (README, .gitignore, or license)
6. Click "Create repository"

## 2. Clone and Set Up the Repository

Run the following commands in Cloud Shell:

```bash
# Clone the empty repository
git clone https://github.com/YOUR_USERNAME/sample-app.git
cd sample-app

# Copy the sample code
gsutil cp -r gs://spls/gsp330/sample-app/* .

# Update region and zone in build files
export REGION="us-east1"
export ZONE="us-east1-c"
for file in cloudbuild-dev.yaml cloudbuild.yaml; do
    sed -i "s/<your-region>/${REGION}/g" "$file"
    sed -i "s/<your-zone>/${ZONE}/g" "$file"
done
```

## 3. Set Up the Master Branch

```bash
# Update the image version in cloudbuild.yaml
sed -i 's/<version>/v1.0/g' cloudbuild.yaml

# Update the container image name in prod/deployment.yaml
# Replace PROJECT_ID with your actual project ID
export PROJECT_ID=$(gcloud config get-value project)
sed -i "s|us-east1-docker.pkg.dev/PROJECT_ID/my-repository/hello-app:v1.0|us-east1-docker.pkg.dev/${PROJECT_ID}/my-repository/hello-app:v1.0|g" prod/deployment.yaml

# Add files, commit, and push to master
git add .
git commit -m "Initial commit with v1.0 code"
git push origin master
```

## 4. Set Up the Dev Branch

```bash
# Create and checkout the dev branch
git checkout -b dev

# Update the image version in cloudbuild-dev.yaml
sed -i 's/<version>/v1.0/g' cloudbuild-dev.yaml

# Update the container image name in dev/deployment.yaml
# Replace PROJECT_ID with your actual project ID
export PROJECT_ID=$(gcloud config get-value project)
sed -i "s|us-east1-docker.pkg.dev/PROJECT_ID/my-repository/hello-app:v1.0|us-east1-docker.pkg.dev/${PROJECT_ID}/my-repository/hello-app:v1.0|g" dev/deployment.yaml

# Commit and push the dev branch
git add .
git commit -m "Initial commit with v1.0 code for dev"
git push origin dev
```

## 5. Update to Version 2.0 on Dev Branch

```bash
# Make sure you're on the dev branch
git checkout dev

# Update main.go to add the red handler function
# This is done by editing the file as shown in main.go (v2.0)

# Update the image version in cloudbuild-dev.yaml
sed -i 's/v1.0/v2.0/g' cloudbuild-dev.yaml

# Update the container image name in dev/deployment.yaml
sed -i 's/v1.0/v2.0/g' dev/deployment.yaml

# Commit and push updates to dev branch
git add .
git commit -m "Update to v2.0 with red handler"
git push origin dev
```

## 6. Update to Version 2.0 on Master Branch

```bash
# Switch to the master branch
git checkout master

# Update main.go to add the red handler function
# This is done by editing the file as shown in main.go (v2.0)

# Update the image version in cloudbuild.yaml
sed -i 's/v1.0/v2.0/g' cloudbuild.yaml

# Update the container image name in prod/deployment.yaml
sed -i 's/v1.0/v2.0/g' prod/deployment.yaml

# Commit and push updates to master branch
git add .
git commit -m "Update to v2.0 with red handler"
git push origin master
```

## 7. Roll Back Production to v1.0

To roll back to version 1.0, you can either:

1. Use the Cloud Build console to rebuild the v1.0 build, or
2. Update the files and push a new commit:

```bash
# Make sure you're on the master branch
git checkout master

# Update the image version in cloudbuild.yaml
sed -i 's/v2.0/v1.0/g' cloudbuild.yaml

# Update the container image name in prod/deployment.yaml
sed -i 's/v2.0/v1.0/g' prod/deployment.yaml

# Commit and push rollback to master branch
git add .
git commit -m "Rollback to v1.0"
git push origin master
```
