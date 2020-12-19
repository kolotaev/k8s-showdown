
k3s-init:
	multipass launch --mem=2G --cpus=1 --disk=20G  --name=primary
	prov=`cat provision-k3s.sh`
	multipass exec primary -- echo $prov | bash
