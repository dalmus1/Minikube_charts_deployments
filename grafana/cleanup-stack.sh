#!/bin/bash

# Colors for output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}Cleaning up LGTM stack...${NC}"

# Delete all deployments, services, and configmaps
kubectl delete -f 7-grafana-deployment.yaml --ignore-not-found=true
kubectl delete -f 6-mimir-deployment.yaml --ignore-not-found=true
kubectl delete -f 5-tempo-deployment.yaml --ignore-not-found=true
kubectl delete -f 4-loki-deployment.yaml --ignore-not-found=true
kubectl delete -f 3-prometheus-deployment.yaml --ignore-not-found=true
kubectl delete -f 2-persistent-volumes.yaml --ignore-not-found=true
kubectl delete -f 1-namespace-and-configs.yaml --ignore-not-found=true

# Optional: Stop minikube
# minikube stop
# minikube delete

echo -e "${GREEN}✓ Cleanup complete${NC}"