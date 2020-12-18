skaf-version:
	./skaffold version


k3s-install:
	prov=`cat provision-k3s.sh`
	@multipass exec primary -- echo $prov | bash
