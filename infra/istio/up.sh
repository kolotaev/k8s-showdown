mkdir -p /tmp/k8s-istio-install
cd /tmp/k8s-istio-install
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.8.1 sh -
sudo mv /tmp/k8s-istio-install/bin/istioctl /usr/bin/istioctl
cd -

istioctl install --set profile=demo -y

# Istio injection
kubectl label namespace stage istio-injection=enabled
