#Quando a gente faz qualquer chamada na api do Kubernetes (API Server)
#A gente é autenticado com uma conta de usuário (User Account)
#Geralmente é a conta admin, a não ser que seja criado uma user account pra cada usuário do cluster.
#USER ACCOUNT é PRA HUMANO/USER
#User account é a nível global/cluster

#Agora um pod, faz isso através de uma service account.
#Ela vai prover uma identidade para o pod...
#Por default, todos os pods executam na service account "default"
#SERVICE ACCOUNT é PRA PROCESSO, O QUE É PROCESSO? POD QUE ESTÁ EM EXECUÇÃO.
#É por isso que toda service account existe a nível de namespace

kubectl get sa minha-sa
NAME       SECRETS   AGE
minha-sa   0         15s

apiVersion: v1
kind: ServiceAccount
metadata:
  name: minha-sa

## Ver como o pod pega a sa default
kubectl run nginx42 --image nginx


#Lab1, vincular a service-account ao
kubectl get po nginx42 -o yaml | grep -i serviceaccount
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
  serviceAccount: minha-sa
  serviceAccountName: minha-sa
      - serviceAccountToken:

#criar uma sa via kubectl
kubectl create sa segunda-sa

#Configuração que não deixa montar as secrets em /run/secrets/kubernetes.io/serviceaccount
root@nginx42:/# cd /run/secrets/kubernetes.io/
root@nginx42:/run/secrets/kubernetes.io# ls -l
total 0
drwxrwxrwt 3 root root 140 Jan 10 18:38 serviceaccount
root@nginx42:/run/secrets/kubernetes.io# cd serviceaccount/
root@nginx42:/run/secrets/kubernetes.io/serviceaccount# ls -l
total 0
lrwxrwxrwx 1 root root 13 Jan 10 18:38 ca.crt -> ..data/ca.crt
lrwxrwxrwx 1 root root 16 Jan 10 18:38 namespace -> ..data/namespace
lrwxrwxrwx 1 root root 12 Jan 10 18:38 token -> ..data/token


apiVersion: v1
kind: ServiceAccount
automountServiceAccountToken: false
metadata:
  name: minha-sa

kubectl exec -it nginx42 -- bash

root@nginx42:/# cd /run/
lock/      nginx.pid
root@nginx42:/# cd /run/

#Obs.: Essa config também pode ser adicionada no pod, ao invés de que na Service Account.