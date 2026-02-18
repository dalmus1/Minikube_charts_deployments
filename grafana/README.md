# Complete LGTM Stack + AlertManager + Prometheus

This deployment includes:
- **Prometheus**: Metrics collection with alert rules
- **AlertManager**: Alert routing and management
- **Loki**: Log aggregation
- **Tempo**: Distributed tracing
- **Mimir**: Long-term metrics storage
- **Grafana**: Visualization and dashboarding

## Features

✅ **Alert Rules**: Pre-configured alert rules for all components
✅ **AlertManager**: Centralized alert management and routing
✅ **Grafana Integration**: View alerts in Grafana
✅ **Prometheus UI**: Direct alert viewing
✅ **AlertManager UI**: Manage alert routing and silencing

## Prerequisites

- Docker Desktop or Docker
- Minikube
- kubectl
- 8GB RAM minimum, 4 CPU cores, 30GB disk space

## Quick Start

1. **Make scripts executable:**
   ```bash
   chmod +x deploy-complete-stack-with-alertmanager.sh cleanup-stack-with-alertmanager.sh
