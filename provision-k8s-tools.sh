MY_IP=`hostname -I | cut -d' ' -f1`

# Install docker
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli
#  && sudo apt-get containerd.io
# Set up docker permissions
sudo groupadd docker
sudo usermod -aG docker ${USER}

# Install k3s
export K3S_KUBECONFIG_MODE="644"
export INSTALL_K3S_EXEC=" --no-deploy servicelb --no-deploy traefik"
# export INSTALL_K3S_EXEC=" --docker --no-deploy servicelb --no-deploy traefik"
curl -sfL https://get.k3s.io | sh -
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
# check it's running
kubectl get nodes -o wide

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

# Install Docker local registry (needed for Skaffold to build images and k3s to consume them with containerd)
docker volume create local_registry
docker container run -d --name registry.local -v local_registry:/var/lib/registry --restart always -p 5000:5000 registry:2

# Create stage k8s namespace
kubectl create ns stage

# Setup bash
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc
echo "alias kc=kubectl" >> ~/.bashrc
echo "alias kcs=\"kubectl -n=stage \"" >> ~/.bashrc
