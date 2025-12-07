# DevOps Workflows in Google Cloud: CI/CD Pipeline Implementation

This repository demonstrates a complete CI/CD pipeline implementation using GitHub, Google Cloud Build, Artifact Registry, and Google Kubernetes Engine (GKE). The project features a simple Go application with automatic build and deployment workflows for both development and production environments.

## Project Overview 

This project implements a CI/CD pipeline for Cymbal Superstore that:
- Uses GitHub for source code management
- Uses Google Artifact Registry to store Docker images
- Uses Google Cloud Build for automated builds and deployments
- Deploys to separate development and production environments on GKE
- Supports versioning and rollbacks

## Application 

The application is a simple Go web server that serves colored squares:
- `/blue` endpoint - Shows a blue square
- `/red` endpoint - Shows a red square (added in v2.0)

## Repository Structure

```
sample-app/
├── cloudbuild.yaml        # Cloud Build config for production deployments
├── cloudbuild-dev.yaml    # Cloud Build config for development deployments
├── Dockerfile             # Docker image definition
├── go.mod                 # Go module definition
├── main.go                # Application source code
├── dev/                   # Development environment Kubernetes manifests
│   └── deployment.yaml    # Kubernetes deployment for dev environment
└── prod/                  # Production environment Kubernetes manifests
    └── deployment.yaml    # Kubernetes deployment for prod environment
```

## Setup Instructions

### Prerequisites
- Google Cloud account with billing enabled
- GitHub account
- `gcloud` CLI installed

### 1. Set Up Google Cloud Project

Enable the required APIs:
```bash
gcloud services enable container.googleapis.com cloudbuild.googleapis.com
```

Grant the Kubernetes Developer role to the Cloud Build service account:
```bash
export PROJECT_ID=$(gcloud config get-value project)
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:$(gcloud projects describe $PROJECT_ID \
--format="value(projectNumber)")@cloudbuild.gserviceaccount.com --role="roles/container.developer"
```

### 2. Configure Git and GitHub

Install GitHub CLI and authenticate:
```bash
curl -sS https://webi.sh/gh | sh
gh auth login
GITHUB_USERNAME=$(gh api user -q ".login")
git config --global user.name "${GITHUB_USERNAME}"
git config --global user.email "${USER_EMAIL}"
```

### 3. Create Artifact Registry Repository

Create a Docker repository to store container images:
```bash
gcloud artifacts repositories create my-repository \
--repository-format=docker \
--location=us-east1 \
--description="Docker repository for sample app"
```

### 4. Create GKE Cluster

Create a GKE cluster with the following configuration:
```bash
gcloud container clusters create hello-cluster \
--zone=us-east1-c \
--release-channel=regular \
--cluster-version=1.29 \
--enable-autoscaling \
--num-nodes=3 \
--min-nodes=2 \
--max-nodes=6
```

Create the development and production namespaces:
```bash
kubectl create namespace dev
kubectl create namespace prod
```

### 5. GitHub Repository Setup

Create a GitHub repository named `sample-app`:
```bash
gh repo create sample-app --public --confirm
```

Clone the repository and populate with sample code:
```bash
git clone https://github.com/$GITHUB_USERNAME/sample-app.git
cd sample-app
gsutil cp -r gs://spls/gsp330/sample-app/* .
```

Update region and zone in build files:
```bash
export REGION="us-east1"
export ZONE="us-east1-c"
for file in cloudbuild-dev.yaml cloudbuild.yaml; do
    sed -i "s/<your-region>/${REGION}/g" "$file"
    sed -i "s/<your-zone>/${ZONE}/g" "$file"
done
```

### 6. Create Cloud Build Triggers

Create triggers in the Google Cloud Console:
1. `sample-app-prod-deploy` for the master branch
2. `sample-app-dev-deploy` for the dev branch

## Deployment Process

### Initial Deployment (v1.0)

#### Development Environment
1. Update `cloudbuild-dev.yaml` with v1.0
2. Update `dev/deployment.yaml` with correct image name
3. Commit and push to the dev branch to trigger the build
4. Create a service to expose the application:

```bash
kubectl expose deployment development-deployment --name=dev-deployment-service \
--type=LoadBalancer --port=8080 --target-port=8080 --namespace=dev
```

#### Production Environment
1. Update `cloudbuild.yaml` with v1.0
2. Update `prod/deployment.yaml` with correct image name
3. Commit and push to the master branch to trigger the build
4. Create a service to expose the application:

```bash
kubectl expose deployment production-deployment --name=prod-deployment-service \
--type=LoadBalancer --port=8080 --target-port=8080 --namespace=prod
```

### Version 2.0 Deployment

For both environments:
1. Update `main.go` to add the `/red` endpoint
2. Update build files to use v2.0
3. Update deployment files with the new image version
4. Commit and push to trigger the builds

### Rolling Back Production

To roll back to a previous version:
1. Find the previous build in Cloud Build history
2. Rebuild using the previous version configuration
3. Verify the rollback was successful by checking the endpoints

## Testing the Application

- Access the blue square: `http://<LOAD_BALANCER_IP>:8080/blue`
- Access the red square (v2.0 only): `http://<LOAD_BALANCER_IP>:8080/red`

## Screenshots

(Add screenshots of successful deployments and application interfaces here)
