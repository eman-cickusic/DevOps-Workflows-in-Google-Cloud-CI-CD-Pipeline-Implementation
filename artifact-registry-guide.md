# Artifact Registry Setup Guide

This guide provides step-by-step instructions for setting up Google Artifact Registry for the DevOps workflows project.

## 1. Create the Artifact Registry Repository

You can create the Artifact Registry repository using either the Google Cloud Console or the `gcloud` command-line tool.

### Using the Google Cloud Console

1. Open the Google Cloud Console and navigate to Artifact Registry > Repositories
2. Click "Create Repository"
3. Configure the repository with the following settings:
   - Name: `my-repository`
   - Format: Docker
   - Mode: Standard
   - Location type: Region
   - Region: `us-east1`
   - Description: "Docker repository for sample app"
4. Click "Create"

### Using the gcloud Command

Run the following command in Cloud Shell:

```bash
gcloud artifacts repositories create my-repository \
--repository-format=docker \
--location=us-east1 \
--description="Docker repository for sample app"
```

## 2. Configure Docker to Use Artifact Registry

Before you can push images to Artifact Registry, you need to configure Docker to authenticate with Artifact Registry:

```bash
gcloud auth configure-docker us-east1-docker.pkg.dev
```

## 3. Verify the Setup

Verify that your Artifact Registry repository has been created correctly:

```bash
gcloud artifacts repositories describe my-repository --location=us-east1
```

The output should show the details of your Artifact Registry repository, including the name, format, and location.

## 4. Understanding the Image Path

In your Docker builds and Kubernetes deployments, you'll reference images using the following format:

```
us-east1-docker.pkg.dev/PROJECT_ID/my-repository/hello-app:TAG
```

Where:
- `us-east1-docker.pkg.dev` is the hostname for Artifact Registry in the us-east1 region
- `PROJECT_ID` is your Google Cloud project ID
- `my-repository` is the name of your Artifact Registry repository
- `hello-app` is the name of your Docker image
- `TAG` is the version tag (like v1.0 or v2.0)

Remember to replace `PROJECT_ID` with your actual project ID in all configuration files.
