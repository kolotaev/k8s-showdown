# Istio injection
kubectl label namespace stage istio-injection=disabled

# Unnstall istio
istioctl x uninstall --purge
