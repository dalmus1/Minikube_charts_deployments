#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Complete LGTM Stack + AlertManager${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Step 1: Set kubectl to minikube
kubectl config use-context minikube

# Step 2: Create namespace and configs
echo -e "${BLUE}[2/6] Creating namespace and configurations...${NC}"
kubectl apply -f 1-namespace-and-configs.yaml
if [ $? -eq 0 ]; then
  echo -e "${GREEN}✓ Namespace and configs created${NC}"
else
  echo -e "${RED}✗ Failed to create namespace and configs${NC}"
  exit 1
fi
echo ""

# Step 3: Create AlertManager config and rules
echo -e "${BLUE}[3/6] Creating AlertManager configuration...${NC}"
kubectl apply -f 8-alertmanager-config.yaml
if [ $? -eq 0 ]; then
  echo -e "${GREEN}✓ AlertManager config created${NC}"
else
  echo -e "${RED}✗ Failed to create AlertManager config${NC}"
  exit 1
fi
echo ""

# Step 4: Create persistent volumes
echo -e "${BLUE}[4/6] Creating persistent volumes...${NC}"
kubectl apply -f 2-persistent-volumes.yaml
# Add AlertManager PVC (extract only PersistentVolumeClaim documents safely)
# Use kubectl dry-run to render then awk to split on '---' and select PVC docs
kubectl apply -f 9-alertmanager-deployment.yaml --dry-run=client -o yaml \
  | awk 'BEGIN{RS="---"; ORS="---\n"} /kind: PersistentVolumeClaim/ {print $0}' \
  | kubectl apply -f -
if [ $? -eq 0 ]; then
  echo -e "${GREEN}✓ Persistent volumes created${NC}"
else
  echo -e "${RED}✗ Failed to create persistent volumes${NC}"
  exit 1
fi
echo ""

# Step 5: Deploy all components
echo -e "${BLUE}[5/6] Deploying monitoring stack components...${NC}"
kubectl apply -f 11-prometheus-updated-deployment.yaml
kubectl apply -f 4-loki-deployment.yaml
kubectl apply -f 5-tempo-deployment.yaml
kubectl apply -f 6-mimir-deployment.yaml
kubectl apply -f 7-grafana-deployment.yaml
kubectl apply -f 9-alertmanager-deployment.yaml

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✓ All components deployed${NC}"
else
  echo -e "${RED}✗ Failed to deploy components${NC}"
  exit 1
fi
echo ""

# Step 6: Wait for pods to be ready
echo -e "${BLUE}[6/6] Waiting for all pods to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app=prometheus -n monitoring --timeout=300s 2>/dev/null || true
kubectl wait --for=condition=ready pod -l app=alertmanager -n monitoring --timeout=300s 2>/dev/null || true
kubectl wait --for=condition=ready pod -l app=loki -n monitoring --timeout=300s 2>/dev/null || true
kubectl wait --for=condition=ready pod -l app=tempo -n monitoring --timeout=300s 2>/dev/null || true
kubectl wait --for=condition=ready pod -l app=mimir -n monitoring --timeout=300s 2>/dev/null || true
kubectl wait --for=condition=ready pod -l app=grafana -n monitoring --timeout=300s 2>/dev/null || true

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  ✓ LGTM Stack + AlertManager Deployed!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

echo -e "${BLUE}Access Information:${NC}"
echo ""
echo "1. Get minikube IP:"
echo -e "   ${GREEN}minikube ip${NC}"
echo ""
echo "2. Option A - Using Minikube Service:"
echo -e "   ${GREEN}minikube service grafana -n monitoring${NC}"
echo -e "   ${GREEN}minikube service prometheus -n monitoring${NC}"
echo -e "   ${GREEN}minikube service alertmanager -n monitoring${NC}"
echo ""
echo "3. Option B - Using Port-Forwarding (in separate terminals):"
echo -e "   ${GREEN}kubectl port-forward -n monitoring svc/grafana 3000:3000${NC}"
echo -e "   ${GREEN}kubectl port-forward -n monitoring svc/prometheus 9090:9090${NC}"
echo -e "   ${GREEN}kubectl port-forward -n monitoring svc/alertmanager 9093:9093${NC}"
echo -e "   ${GREEN}kubectl port-forward -n monitoring svc/loki 3100:3100${NC}"
echo -e "   ${GREEN}kubectl port-forward -n monitoring svc/tempo 3200:3200${NC}"
echo -e "   ${GREEN}kubectl port-forward -n monitoring svc/mimir 9009:9009${NC}"
echo ""
echo -e "${BLUE}Credentials:${NC}"
echo "   Username: admin"
echo "   Password: admin"
echo ""
echo -e "${BLUE}Component Access:${NC}"
echo "   Grafana:      http://localhost:3000"
echo "   Prometheus:   http://localhost:9090"
echo "   AlertManager: http://localhost:9093"
echo "   Loki:         http://localhost:3100"
echo "   Tempo:        http://localhost:3200"
echo "   Mimir:        http://localhost:9009"
echo ""
echo -e "${BLUE}Check deployment status:${NC}"
echo -e "   ${GREEN}kubectl get pods -n monitoring${NC}"
echo -e "   ${GREEN}kubectl get svc -n monitoring${NC}"
echo ""
echo -e "${BLUE}View Prometheus alerts:${NC}"
echo -e "   ${GREEN}http://localhost:9090/alerts${NC}"
echo ""
echo -e "${BLUE}View AlertManager:${NC}"
echo -e "   ${GREEN}http://localhost:9093${NC}"
echo ""
