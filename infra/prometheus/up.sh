kubectl create ns infra || echo "NS is already there"

kubectl apply -n=infra -f configmap.yaml
kubectl apply -n=infra -f deployment.yaml

