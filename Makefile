
k3s-init:
	@multipass launch --mem=2G --cpus=1 --disk=20G  --name=primary
	@multipass transfer ./provision-k8s-tools.sh primary:/tmp/provision-k8s-tools.sh
	@multipass exec primary -- sudo chmod +x /tmp/provision-k8s-tools.sh
	@multipass exec primary -- bash -lc /tmp/provision-k8s-tools.sh
