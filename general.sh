#DICAS VIM
#Substituir strings:
:%s/deploy-1/deploy-30

cat ~/.vimrc 
set expandtab
set tabstop=2
set shiftwidth=2


#Selecionmar:
v

#Copiar múltiplas linhas?
y

#Paste
P

################
################

#Matchlabels é sempre dentro de spec, seja container ou pvc, por exemplo, ou svc
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
spec:
  resources:
    requests:
      storage: 500Mi
  accessModes:
  - ReadWriteOnce
  selector:
    matchLabels:
      db: mysql

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

#Listar todos os pods:
kubectl get po -A

#Listar quantidade total de pods running no cluster
kubectl get po -A | grep -i running | wc -l
