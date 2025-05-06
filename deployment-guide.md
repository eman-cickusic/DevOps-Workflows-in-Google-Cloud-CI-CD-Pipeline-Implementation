# Deployment and Verification Guide

This guide provides step-by-step instructions for deploying and verifying the application in both development and production environments.

## 1. Initial Deployment (v1.0)

After setting up the GitHub repository and Cloud Build triggers, the initial deployment happens automatically when you push to the respective branches. To verify and expose the deployments:

### Development Environment

1. Connect to your GKE cluster:
```bash
gcloud container clusters get-credentials hello-cluster --zone us-east1-c
```

2. Verify the deployment in the dev namespace:
```bash
kubectl get deployments -n dev
```

3. Expose the development deployment with a LoadBalancer service:
```bash
kubectl expose deployment development-deployment --name=dev-deployment-service \
--type=LoadBalancer --port=8080 --target-port=8080 --namespace=dev
```

4. Get the external IP of the service:
```bash
kubectl get services -n dev
```

5. Access the blue square by visiting:
```
http://<EXTERNAL_IP>:8080/blue
```
The page should display a blue square.

### Production Environment

1. Verify the deployment in the prod namespace:
```bash
kubectl get deployments -n prod
```

2. Expose the production deployment with a LoadBalancer service:
```bash
kubectl expose deployment production-deployment --name=prod-deployment-service \
--type=LoadBalancer --port=8080 --target-port=8080 --namespace=prod
```

3. Get the external IP of the service:
```bash
kubectl get services -n prod
```

4. Access the blue square by visiting:
```
http://<EXTERNAL_IP>:8080/blue
```
The page should display a blue square.

## 2. Update to Version 2.0

After pushing the v2.0 updates to both branches, verify that the new version is deployed and the red endpoint is accessible.

### Development Environment

1. Verify the updated deployment in the dev namespace:
```bash
kubectl get deployments -n dev
```
You should see that the deployment has been updated.

2. Check the current image version:
```bash
kubectl describe deployment development-deployment -n dev | grep Image
```
The image should be v2.0.

3. Access the red square by visiting:
```
http://<DEV_EXTERNAL_IP>:8080/red
```
The page should display a red square, confirming that v2.0 is deployed.

### Production Environment

1. Verify the updated deployment in the prod namespace:
```bash
kubectl get deployments -n prod
```

2. Check the current image version:
```bash
kubectl describe deployment production-deployment -n prod | grep Image
```
The image should be v2.0.

3. Access the red square by visiting:
```
http://<PROD_EXTERNAL_IP>:8080/red
```
The page should display a red square, confirming that v2.0 is deployed.

## 3. Roll Back Production to v1.0

There are two ways to roll back to the previous version:

### Method 1: Using Cloud Build History

1. Navigate to Cloud Build History in the Google Cloud Console
2. Find the build that deployed v1.0 to production
3. Click on the build and select "Rebuild"
4. This will redeploy v1.0 to the production environment

### Method 2: Using Git to Revert to v1.0

1. Update the code to use v1.0 as described in the GitHub Repository Setup Guide
2. Push the changes to trigger a new build
3. This will redeploy v1.0 to the production environment

### Verify the Rollback

1. Check the current image version:
```bash
kubectl describe deployment production-deployment -n prod | grep Image
```
The image should be v1.0.

2. Access the blue square by visiting:
```
http://<PROD_EXTERNAL_IP>:8080/blue
```
The page should display a blue square.

3. Try to access the red square by visiting:
```
http://<PROD_EXTERNAL_IP>:8080/red
```
This should return a 404 error, confirming that the application has been rolled back to v1.0, which does not have the red endpoint.
