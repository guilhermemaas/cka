#Buscar todas as API's disponíveis no cluster:
kubectl api-resources

#Listar todos os contextos do kube config:
kubectl config get-contexts

#Cluster info
kubectl cluster-info --context kind-cka

#Auto complete no kubectl
echo 'source <(kubectl completion bash)' >>~/.bashrc

#Buscar mais de um tipo de objeto
kubectl get deploy,rs,pod

#Dar watch em algum comando:
watch -n0 kubectl get pod

#Adicionar um container ao final de um arquivo de deployment:
kubectl run nginx5 --image nginx --env tier=b --port 80 --dry-run=client -o yaml --cat /etc/hosts >> deploy.yml