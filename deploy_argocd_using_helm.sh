helm repo add argocd https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argocd/argo-cd -n argocd
kubectl port-forward service/argocd-server -n default 8181:443

https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-1-ssl-passthrough
https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-2multiple-ingress-objects-and-hosts
kubectl -n default get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d

