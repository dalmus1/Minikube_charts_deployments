kubectl -n monitoring port-forward svc/grafana 3000:3000 > /dev/null 2>&1 &
kubectl -n monitoring port-forward svc/alertmanager 9093:9093 > /dev/null 2>&1 &
kubectl -n monitoring port-forward svc/loki 3100:3100 > /dev/null 2>&1 &
kubectl -n monitoring port-forward svc/mimir 9009:9009 > /dev/null 2>&1 &
kubectl -n monitoring port-forward svc/tempo 3200:3200 > /dev/null 2>&1 &

