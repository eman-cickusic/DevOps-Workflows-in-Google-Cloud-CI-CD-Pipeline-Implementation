# GKE Cluster Creation Guide

This guide provides step-by-step instructions for creating the Google Kubernetes Engine (GKE) cluster for the DevOps workflows project.

## 1. Create the GKE Cluster

You can create the GKE cluster using either the Google Cloud Console or the `gcloud` command-line tool.

### Using the Google Cloud Console

1. Open the Google Cloud Console and navigate to Kubernetes Engine > Clusters
2. Click "Create"
3. Choose "Standard" cluster
4. Configure the cluster with the following settings:
   - Name: `hello-cluster`
   - Location type: Zonal
   - Zone: `us-east1-c`
   - Control plane version: 1.29 or newer (select from Regular release channel)
   - Node pool:
     - Number of nodes: 3
     - Enable autoscaling: Yes
     - Minimum nodes: 2
     - Maximum nodes: 6
5. Click "Create"

### Using the gcloud Command

Run the following command in Cloud Shell:

```bash
gcloud container clusters create hello-cluster \
--zone=us-east1-c \
--release-channel=regular \
--cluster-version=1.29.3-gke.1070000 \
--enable-autoscaling \
--num-nodes=3 \
--min-nodes=2 \
--max-nodes=6
```

## 2. Create the Namespaces

After the cluster has been created, you need to create two namespaces for your development and production environments:

1. Connect to your new cluster:
```bash
gcloud container clusters get-credentials hello-cluster --zone us-east1-c
```

2. Create the dev namespace:
```bash
kubectl create namespace dev
```

3. Create the prod namespace:
```bash
kubectl create namespace prod
```

## 3. Verify the Setup

Verify that your cluster and namespaces have been created correctly:

1. Check the cluster status:
```bash
gcloud container clusters describe hello-cluster --zone us-east1-c
```

2. Check that the namespaces were created:
```bash
kubectl get namespaces
```

You should see both `dev` and `prod` namespaces in the list.
