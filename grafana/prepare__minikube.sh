#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting Minikube...${NC}"
minikube start --memory=4096 --cpus=2 --disk-size=20g

