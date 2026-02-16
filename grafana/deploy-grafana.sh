#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Ensure kubectl context set to minikube.${NC}"
kubectl config use-context minikube

echo -e "${BLUE}Applying Grafana deployment...${NC}"
kubectl apply -f grafana-deployment.yaml

echo -e "${BLUE}Creating ConfigMaps...${NC}"
kubectl apply -f grafana-datasources-config.yaml
kubectl apply -f grafana-dashboards-provider.yaml
kubectl apply -f grafana-sample-dashboard.yaml

echo -e "${BLUE}Waiting for Grafana to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app=grafana -n monitoring --timeout=300s

echo -e "${GREEN}✓ Grafana deployed successfully!${NC}"
echo ""
echo -e "${BLUE}Access Grafana using one of these methods:${NC}"
echo ""
echo "1. Using minikube service:"
echo -e "   ${GREEN}minikube service grafana --namespace=monitoring${NC}"
echo ""
echo "2. Using port-forwarding:"
echo -e "   ${GREEN}kubectl port-forward -n monitoring svc/grafana 3000:3000${NC}"
echo ""
echo "Default credentials:"
echo "   Username: admin"
echo "   Password: admin"
