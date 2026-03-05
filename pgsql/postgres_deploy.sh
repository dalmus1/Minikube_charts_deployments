kubectl create namespace db --dry-run=client -o yaml | kubectl apply -f -
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install pg bitnami/postgresql -n db \
  --set imgiage.tag=16 \
  --set auth.postgresPassword='postgresmin' \
  --set auth.username='guacamole' \
  --set auth.password='Gu@c@m0l3' \
  --set auth.database='guacamole' \
  --set primary.persistence.enabled=true \
  --set primary.persistence.size=5Gi
