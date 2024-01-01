Exercícios CKA e CKAD
1 Crie um POD com as seguintes características utilizando kubectl:
nome: ex-1
image: nginx
port: 80

kubectl run ex-1 --image nginx --port 80

========================

2 Crie um POD com as seguintes características utilizando yaml:
nome: ex-2
image: nginx:latest
port: 80

kubectl run ex-2 --image nginx:latest --port 80

========================

3 Crie um POD com as seguintes características:
nome: ex-3
container 1
image: nginx
port: 80
container 2
image: redis
port: 6379

kubectl run ex-3 --image nginx --port 80 --dry-run=client -o yaml >> exer3.yaml

========================

4 Liste o nome de todos os pods no namespace default.

kubectl get pods -n default

  1 apiVersion: v1                                                                                                                                                           2 kind: Pod
  3 metadata:
  4   creationTimestamp: null
  5   labels:
  6     run: ex-3
  7   name: ex-3
  8 spec:
  9   containers:
 10   - image: nginx
 11     name: ex-3-nginx
 12     ports:
 13     - containerPort: 80
 14     resources: {}
 15   - image: redis
 16     name: ex-3-redis
 17     ports:
 18     - containerPort: 6379
 19   dnsPolicy: ClusterFirst
 20   restartPolicy: Always
 21 status: {}

========================

5 Liste o nome de todos os pods no namespace default e salvar os nomes no arquivo /tmp/pods.

kubectl get pods -n default >> /tmp/pods
cat /tmp/pods

========================

6 Utilizando o pod criado no exercício 3 fazer um teste do conexão entre os containers nginx e redis.

kubectl exec -it ex-3 -c ex-3-nginx
    apt update && apt install telnet
    telnet ex-3 6379 #Testar a porta do Redis

========================

7 Obtenha todos os detalhes do pod criado no exercício 1 e também direcione a saída do comando para o arquivo /tmp/pod1.

kubectl get pod ex-1 -o yaml >> /tmp/pod1
cat /tmp/pod1

========================

8 Delete o pod criado no exercício 1.

kubectl delete pod ex-1

========================

9 Delete o pod criado no exercício 3 sem nenhum delay.

kubectl detel pod ex-3 --force --grace-period 0

========================

10 Altere a imagem do pod criado no exercício 2 para nginx:alpine

kubectl edit pod ex-2

========================

11 Obtenha a versão do imagem do container do CoreDNS localizado no namespace kube-system e salve em /tmp/core-image.

kubectl get pod coredns-5d78c9869d-hx72g -n kube-system -o yaml | grep image:
echo "v1.10.1" >> /tmp/core-image
cat /tmp/core-image

========================

12 Crie um POD com as seguintes características:
nome: ex-12
image: nginx
port: 80
Após isso obtenha todas as variáveis de ambiente desse container e salve em /tmp/env-12

kubectl run ex-12 --image nginx --port 80
kubectl exec -it ex-12 -- env
kubectl exec -it ex-12 -- env >> /tmp/env-12
cat /tmp/env-12

========================

13 Crie um POD com as seguintes características:
nome: ex-13
image: nginx
port: 80
env: tier=web
env: enrironment=dev
Após isso obtenha todas as variáveis de ambiente desse container e salve em /tmp/env-13

kubectl run ex-13 --image nginx --port 80 --env=tier=web --env=environment=dev
kubectl exec -it ex-13 -- env >> /tmp/env-13
cat /tmp/env-13

========================

14 Crie um POD com as seguintes características:
nome: ex-14
image: busybox
args: sleep 3600
Obtenha todas as variáveis de ambiente desse container e salve em /tmp/env-14

kubectl run ex-14 --image busybox -o yaml >> ex-14.yml

  1 apiVersion: v1                                                                                                                                                           2 kind: Pod
  3 metadata:
  4   labels:
  5     run: ex-14
  6   name: ex-14
  7 spec:
  8   containers:
  9   - image: busybox
 10     name: ex-14
 11     command: ["sleep"]
 12     args: ["3600"]
 13   dnsPolicy: ClusterFirst
 14   restartPolicy: Always

 kubectl exec -it ex-14 -- env >> /tmp/env-14

========================

15 Crie um POD com as seguintes características:
nome: ex-15
image: busybox
args: sleep 3600
Após isso acesse o shell desse container e execute o comando ID

kubectl run ex-15 --image busybox --dry-run=client -o yaml >> ex-15.yml
vim ex-15.yml
kubectl apply -f ex-15.yml
kubectl exec -it ex-15 -- id
uid=0(root) gid=0(root) groups=0(root),10(wheel)

========================

16 Delete todos os pods no namespace default

kubectl delete pod --all -n default --force --grace-period 0

========================

17 Crie um Deployment com as seguintes características:
nome: deploy-1
image: nginx
port: 80
replicas: 1

kubectl run ex-17 --image nginx --dry-run=client -o yaml >> ex-17.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: ex-17
spec:
  selector: 
    matchLabels:
      app: "ex-17"
  replicas: 1
  template:
    metadata:
      labels:
        app: "ex-17"
    spec:
      containers:
      - image: nginx
        name: ex-17
        resources: {}
        ports:
        - containerPort: 80
      dnsPolicy: ClusterFirst
      restartPolicy: Always

kubectl apply -f ex-17.yml

========================

18 Consulte o status do Deployment criado anteriormente.

kubectl describe deploy ex-17

========================

19 Altere a imagem do deployment para nginx:alpine.

kubectl edit deploy ex-17

========================

20 Consulte todos os ReplicaSet criados por esse deployment.

kubectl get rs | grep ex-17

========================

21 Altere a image do deployment para nginx:latest e adicione um motivo de causa.

kubectl set image deploy ex-17 ex-17=nginx:alpine --record=true
kubectl rollout history deploy ex-17

========================

22 Agora volte esse deployment para "revison 1".

kubectl rollout undo deploy ex-17 --to-revision=1

========================

23 Verifique qual imagem o deployment está utilizando e grave em /tmp/deploy-image.

kubectl describe deploy ex-17 | grep Image
kubectl describe deploy ex-17 | grep Image >> /tmp/deploy-image
cat /tmp/deploy-image

========================

24 Escale esse deployment para 5 replicas utilizando o kubectl.

kubectl scale deploy ex-17 --replicas=5

========================

25 Escale esse deployment para 2 replicas utilizando o kubectl edit.

kubectl edit deploy ex-17
Editar em spec.replicas

========================

26 Pause o deployment.

kubectl rollout pause deploy ex-17

========================

27 Altere a image do deployment para nginx:alpine.

kubectl set image deploy ex-17 ex-17=nginx:alpine --record=true

========================

28 Agora tire o pause deste deployment.

kubectl set image deploy ex-17 ex-17=nginx:alpine --record=true
kubectl rollout history deploy ex-17
kubectl rollout resume deploy ex-17
kubectl rollout history deploy ex-17

========================

29 Verifique qual imagem o deployment está utilizando e grave em /tmp/deploy-image-pause.

kubectl describe deploy ex-17 | grep Image >> /tmp/deploy-image-pause
cat /tmp/deploy-image-pause
#Image:        nginx:alpine

========================

30 Crie um Deployment com as seguintes características utilizando um yaml:
nome: deploy-30
replicas: 5
container 1
name: web
image: nginx 
port: 80 
env: tier=web
env: environment=prod
container 2
nome: sleep
image: busybox
command: sleep 3600

apiVersion: apps/v1
kind: Deployment
metadata:
  name: deploy-30
spec:
  replicas: 5  
  selector:
    matchLabels:
      app: deploy-30
  template:
    metadata:
      labels:
        app: deploy-30
    spec:
      containers:
      - image: nginx
        name: web
        ports:
        - containerPort: 80
        env:
        - name: tier
          value: web
        - name: environment
          value: prod
      - image: busybox
        name: sleep
        command: ["sleep"]
        args: ["3600"]

========================

31 Delete todos deployments no namespace default

kubectl delete deploy --all -n default

========================

32 Criar um ConfiMap com as seguintes características utilizando um yaml:
nome: env-configs
IP=10.0.0.1
SERVER=nginx

apiVersion: v1
kind: ConfigMap
metadata:
  name: env-configs
data:
  IP: 10.0.0.1
  SERVER: nginx

========================

33 Verifique o ConfiMap criado.

kubectl describe cm env-configs

========================

34 Obtenha todos os dados do ConfiMap criado para /tmp/configmap.

kubectl describe cm env-configs >> /tmp/configmap
cat /tmp/configmap

========================

35 Crie um ConfiMap com as seguintes características utilizando o kubectl:
nome: env-configs-kubectl
tier=web
server=homolog

kubectl create cm env-configs-kubectl --from-literal=tier=web --from-literal=server=homolog
kubectl describe cm env-configs-kubectl
========================

36 Crie um POD com as seguintes características:
nome: ex-cm-pod1
image: nginx
port: 80 
Agora monte o configMap env-configs-kubectl como volume  em /data

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: ex-36
  name: ex-36
spec:
  containers:
  - image: nginx
    name: ex-36
    ports:
    - containerPort: 80
    volumeMounts:
    - name: env-configs-kubectl
      mountPath: /data
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: env-configs-kubectl
    configMap:
      name: env-configs-kubectl
   

kubectl run ex-36 --image nginx --port 80 --dry-run=client -o yaml >> ex-36.yml
kubectl replace -f ex-36.yml --force --grace-period 0
kubectl exec -it ex-36 -- ls /data
========================

37 Altere o pod ex-cm-pod1, agora montando somente o item tier agora com o nome ambiente.conf em /data.


kubectl exec -it ex-cm-pod1 -- cat /data/ambiente.conf

apiVersion: v1
kind: Pod
metadata:
  name: ex-cm-pod1
spec:
  containers:
  - image: nginx
    name: ex-36
    ports:
    - containerPort: 80
    volumeMounts:
    - name: env-configs-kubectl
      mountPath: /data
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: env-configs-kubectl
    configMap:
      name: env-configs-kubectl
      items:
      - key: tier
        path: ambiente.conf 
========================

38 Altere o pod ex-cm-pod1, remove todos os volumes e exporte o configMap completo como variáveis de ambiente. Após isso execute o comando ENV.

kubectl exec -it ex-cm-pod1 -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=ex-cm-pod1
NGINX_VERSION=1.25.3
NJS_VERSION=0.8.2
PKG_RELEASE=1~bookworm
tier=web,
server=homolog
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
TERM=xterm
HOME=/root

========================

39 Altere o pod ex-cm-pod1, agora exporte somente o valor do item server para variável ENVIRONMENT. Após isso execute o comando ENV.

kubectl exec -it ex-cm-pod1 -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=ex-cm-pod1
NGINX_VERSION=1.25.3
NJS_VERSION=0.8.2
PKG_RELEASE=1~bookworm
ENVIRONMENT=homolog
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.96.0.1:443
TERM=xterm
HOME=/root

========================

40 Altere o configMap env-configs-kubectl mude o valor de server para prod e faça essa alteração refletir no pod criado anteriormente.

kubectl exec -it ex-cm-pod1 -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=ex-cm-pod1
NGINX_VERSION=1.25.3
NJS_VERSION=0.8.2
PKG_RELEASE=1~bookworm
ENVIRONMENT=prod
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
TERM=xterm
HOME=/root

========================

41 Altere o configMap env-configs-kubectl para imutável.

kubectl get cm env-configs-kubectl -o yaml
apiVersion: v1
data:
  server: prod
  tier: web
immutable: true
kind: ConfigMap
metadata:
  creationTimestamp: "2024-01-01T18:48:37Z"
  name: env-configs-kubectl
  namespace: default
  resourceVersion: "1048127"
  uid: 22670b87-c9d8-4b3d-909b-c75b8dbf3a29

========================

42 Delete todos os pods e cofigmaps e pods criados anteriormente.

kubectl delete pods ex-30 ex-cm-pod1
kubectl delete cm env-configs env-configs-kubectl

========================

43 Crie uma Secret com as seguintes características utilizando um yaml:
nome: user-secret
user=superadmin
pass=minhasenhasupersegura

echo "superadmin" | base64 #c3VwZXJhZG1pbg== | echo "c3VwZXJhZG1pbg==" | base64 -d
echo "minhasenhasupersegura" | base64 #bWluaGFzZW5oYXN1cGVyc2VndXJh

kubectl describe secret user-secret
Name:         user-secret
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
password:  21 bytes
user:      10 bytes

========================

44 Verifique a Secret criada.

kubectl get secret user-secret
NAME          TYPE     DATA   AGE
user-secret   Opaque   2      52s

========================

45 Obtenha os dados da Secret criada para /tmp/secret e descriptografe seus valores em /tmp/decrypt

kubectl get secret user-secret -o yaml >> /tmp/secret
kubectl get secret user-secret -o yaml >> /tmp/decrypt

kubectl get secret <nome-da-secret> -o=jsonpath='{.data}'
kubectl get secret <nome-da-secret> -o=jsonpath='{.data.<chave>}' | base64 --decode

kubectl get secret user-secret -o jsonpath='{.data.user}' >> /tmp/secret
kubectl get secret user-secret -o jsonpath='{.data.password}' >> /tmp/secret
kubectl get secret user-secret -o jsonpath='{.data.user}' | base64 -d  >> /tmp/decrypt
kubectl get secret user-secret -o jsonpath='{.data.password}' | base64 -d  >> /tmp/decrypt

========================

46 Crie uma Secret com as seguintes características utilizando o kubectl:
nome: user-secret-kubectl
user=newuser #bmV3dXNlcg==
pass=agoraeseguraem #YWdvcmFlc2VndXJhZW0=

kubectl create secret generic user-secret-kubectl --from-literal=user='bmV3dXNlcg==' --from-literal=pass='YWdvcmFlc2VndXJhZW0='

kubectl replace secret generic user-secret-kubectl --from-literal=user=newuser --from-literal=pass=agoraeseguraem

========================

47 Crie um POD com as seguintes características:
nome: ex-secret-pod1
image: nginx
port: 80 
Agora monte a secret user-secret-kubectl como volume  em /secret

kubectl exec -it ex-secret-pod1 -- cat /secret/user
newuser

kubectl exec -it ex-secret-pod1 -- cat /secret/pass    
agoraeseguraem

========================

48 Altere o pod ex-secret-pod1, montando somente o item user agora com o nome user.conf em /secret

kubectl exec -it ex-secret-pod1 -- cat /secret/user.conf
newuser

========================

49 Altere o pod ex-secret-pod1, remove todos os volumes e exporte a secret completa como variáveis de ambiente, após isso execute o comando ENV

kubectl exec -it ex-secret-pod1 -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=ex-secret-pod1
NGINX_VERSION=1.25.3
NJS_VERSION=0.8.2
PKG_RELEASE=1~bookworm
pass=agoraeseguraem
user=newuser
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
TERM=xterm
HOME=/root

========================

50 Altere o pod ex-secret-pod1, agora exporte somente o valor do item pass para variável SENHA, após isso execute o comando ENV

kubectl exec -it ex-secret-pod1 -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=ex-secret-pod1
NGINX_VERSION=1.25.3
NJS_VERSION=0.8.2
PKG_RELEASE=1~bookworm
SENHA=newuser
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
TERM=xterm
HOME=/root

========================

51 Altere a secret user-secret-kubectl e mude o valor de pass para minhanovasenhasegura e faça essa alteração refletir no pod criado anteriormente

kubectl delete secret user-secret-kubectl
kubectl create secret generic user-secret-kubectl --from-literal=user=newuser --from-literal=pass=minhanovasenhasegura

========================

52 Altere a secret user-secret-kubectl para imutável

immutable: true