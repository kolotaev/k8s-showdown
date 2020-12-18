export K3S_KUBECONFIG_MODE="644"
export INSTALL_K3S_EXEC=" --no-deploy servicelb --no-deploy traefik"

curl -sfL https://get.k3s.io | sh -
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

MY_IP=`hostname -I | cut -d' ' -f1`

# check it's running
kubectl get nodes -o wide

# Install docker
sudo snap install docker
sudo usermod -aG docker ${USER}
sudo chmod 666 /var/run/docker.sock

# Docker local registry
# docker volume create local_registry
# docker container run -d --name registry.local -v local_registry:/var/lib/registry --restart always -p 5000:5000 registry:2

# Install Helm
mkdir -p /tmp/k8s-tools-install
cd /tmp/k8s-tools-install
wget https://get.helm.sh/helm-v3.4.2-linux-amd64.tar.gz
tar -zxvf helm-v3.4.2-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
cd -

# Install skaffold
cd /tmp/k8s-tools-install
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
sudo install skaffold /usr/local/bin/
cd -

# Install required helms
helm repo add stable https://charts.helm.sh/stable
helm repo add bitnami https://charts.bitnami.com/bitnami

helm install metallb bitnami/metallb --namespace kube-system \
  --set configInline.address-pools[0].name=default \
  --set configInline.address-pools[0].protocol=layer2 \
  --set configInline.address-pools[0].addresses[0]=$MY_IP-$MY_IP

helm install nginx-ingress stable/nginx-ingress --namespace kube-system \
    --set defaultBackend.enabled=false
kubectl get services  -n kube-system -l app=nginx-ingress -o wide

# Setup bash
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc
echo "alias kc=kubectl" >> ~/.bashrc
echo "alias kcs=\"kubectl -n=stage \"" >> ~/.bashrc
