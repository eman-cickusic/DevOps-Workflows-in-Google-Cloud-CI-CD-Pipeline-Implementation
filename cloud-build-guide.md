# Cloud Build Triggers Setup Guide

This guide provides step-by-step instructions for setting up the Cloud Build triggers for the DevOps workflows project.

## 1. Create the Production Build Trigger

1. Open the Google Cloud Console and navigate to Cloud Build > Triggers
2. Click "Create Trigger"
3. Configure the trigger with the following settings:
   - Name: `sample-app-prod-deploy`
   - Region: `us-east1`
   - Event: `Push to a branch`
   - Source:
     - Repository: Select "Connect to a new repository"
     - Select GitHub (Cloud Build GitHub App) as the source provider
     - Authenticate and select your `sample-app` repository
   - Branch: `^master$` (regex for exact match)
   - Configuration:
     - Type: Cloud Build configuration file (yaml or json)
     - Location: Repository
     - Cloud Build configuration file location: `cloudbuild.yaml`
4. Click "Create"

## 2. Create the Development Build Trigger

1. In the Cloud Build > Triggers page, click "Create Trigger" again
2. Configure the trigger with the following settings:
   - Name: `sample-app-dev-deploy`
   - Region: `us-east1`
   - Event: `Push to a branch`
   - Source:
     - Repository: Select your already connected `sample-app` repository
   - Branch: `^dev$` (regex for exact match)
   - Configuration:
     - Type: Cloud Build configuration file (yaml or json)
     - Location: Repository
     - Cloud Build configuration file location: `cloudbuild-dev.yaml`
3. Click "Create"