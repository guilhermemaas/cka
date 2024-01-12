#Conseguimos trabalhar com IPs e portas, camadas 3 e 4 do modelo OSI.

#O que conseguimos fazer (Tipo):
Allow -> Liberar tráfego.
Deny -> Bloquear tráfego.

#O que define quem vai ser controlado pela policy?
POD - PodSelector
Namespaces - namespaceSelector
BlocoIP - ipBlock

#Vale tanto para origem como para destino

##Fluxo:
Ingress - Entrada
Egress - Saída

#Exemplo
Agress           Ingress
POD   A    ->    POD  B

Saída do pod A, Entrada do pod B

Egress     ->    Ingress
POD  B     ->    POD  A

##Importante!!!!!!!
#Uma vez que foi aplicado QUALQUER regra pra um Pod, ACABOU! só o que estiver na regra vai funcionar.

#Laboratório
#3 pods/services
kubectl run pod-a --image nginx --port 80
kubectl run pod-b --image nginx --port 80
kubectl run pod-c --image nginx --port 80

kubectl create ns full-access

kubectl run full-pod-a --image nginx --port 80
kubectl run full-pod-b --image nginx --port 80
kubectl run full-pod-c --image nginx --port 80

kubectl expose pod pod-a target-port 80 --port 80
kubectl expose pod pod-b target-port 80 --port 80
kubectl expose pod pod-c target-port 80 --port 80

####LAB1
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ingress-pod-c
spec:
  podSelector:
    matchLabels:
      run: pod-c
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          run: pod-a
    ports:
    - protocol: TCP
      port: 80

#Buscar as networkpolicys:
kubectl get networkpolicy

Nesse caso só o pod-a poderá conseguir chamar o pod-c na porta 80.

###
###Lab2
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ingress-pod-c
spec:
  podSelector:
    matchLabels:
      run: pod-c
  policyTypes:
  - Ingress
  ingress:
  - from:
    #Essa lista tem o seguinte comportamento:
    #ou podSelector...
    - podSelector:
        matchLabels:
          run: pod-a
    #ou namespaceSelector... Ou uma regra, ou outra.
    - namespaceSelector:
        matchLabels:
          acesso: liberado
    ports:
    - protocol: TCP
      port: 80

#chamar um svc de um namespace pra outro:
#Deu certo:
kubectl exec -it full-pod-a -n full-access -- curl pod-a.default.svc
kubectl exec -it full-pod-a -n full-access -- curl pod-b.default.svc

#Não deu
kubectl exec -it full-pod-a -n full-access -- curl pod-c.default.svc
#PQ?
#Falta a label acesso: liberado pra dar match
kubectl label ns full-access acesso=liberado

#AGORA FOI!!!
kubectl exec -it full-pod-a -n full-access -- curl pod-c.default.svc
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>

#Listar labels
kubectl get po -n full-access --show-labels

###
#LAB 3
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ingress-pod-c
spec:
  podSelector:
    matchLabels:
      run: pod-c
  policyTypes:
  - Ingress
  ingress:
  - from:
    #Essa lista tem o seguinte comportamento:
    - podSelector:
        matchLabels:
          run: full-pod-a
      namespaceSelector:
        matchLabels:
          acesso: liberado
      #Se as regras estiverem na mesma lista vai ter o comportamento de AND e não de OR
    ports:
    - protocol: TCP
      port: 80

#IP do pod-c 10.44.0.7

#Só o que estiver no namespace com lable "acesso: liberado" e tiver a label "full-pod-a" poderá acessar o pod-c do namespace default

#Não vai funcionar:
kubectl exec -it full-pod-b -n full-access -- curl 10.44.0.7
kubectl exec -it full-pod-b -n full-access -- curl pod-c.default.svc

#Vai funcionar: 
kubectl exec -it full-pod-a -n full-access -- curl 10.44.0.7
kubectl exec -it full-pod-a -n full-access -- curl pod-c.default.svc

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>

#não vai funcionar
kubectl exec -it pod-a -- curl 10.44.0.7
kubectl exec -it pod-a -- curl pod-c.default.svc

###
#Laboratorio 3 Egress (Saída):
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: egress-pod-c
spec:
  podSelector:
    matchLabels:
      run: pod-c
  policyTypes:
  - Egress
  egress:
  - to:
    #Essa lista tem o seguinte comportamento:
    #liberar somente o tráfego de saída para os pods/service com a label pod-a
    - podSelector:
        matchLabels:
          run: pod-a
    ports:
    - protocol: TCP
      port: 80

A saída de dentro do pod-c, só vai funcionar pro pod-a. No entanto só via IP, não resolve nome pelo SVC
TEMOS um problema, foi cortado também a saída pra resolver dns xd

#Liberar o CoreDNS no egress (saída):
#Ele trabalha na porta 53/TCP e 53/UDP

    - protocol: TCP
      port: 53
    - protocol: UDP
      port: 53

#Só que ele roda no kube-system (o CordeDNs), então tem que também ter uma regra pra namespace.
kubectl get ns --show-labels
NAME              STATUS   AGE   LABELS
default           Active   24h   kubernetes.io/metadata.name=default
full-access       Active   71m   acesso=liberado,kubernetes.io/metadata.name=full-access
kube-node-lease   Active   24h   kubernetes.io/metadata.name=kube-node-lease
kube-public       Active   24h   kubernetes.io/metadata.name=kube-public
kube-system       Active   24h   kubernetes.io/metadata.name=kube-system

#Então ficaria assim:
    - podSelector:
        matchLabels:
          run: pod-a
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: TCP
      port: 80
    - protocol: TCP
      port: 53
    - protocol: UDP
      port: 53

#Obs.: Não pode ser um operador "AND" por que os objetos selecionados não existem no mesmo namespace.

#Deu certo!
kubectl exec -it pod-c -- curl pod-a
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>

##Famosas regras que bloqueiam, ou liberam tudo. Pra todos os pods no namespace

#QUE LIBERA TUDO
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-all-ingress
spec:
  podSelector: {} #aplica pra todos os pods do namespace
  policyTypes:
  - Ingress
  ingress:
  - {}

#QUE BLOQUEIA TUDO. É parecido, mas é só não colocar regra nenhuma xd:
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-ingress
spec:
  podSelector: {} #aplica pra todos os pods do namespace
  policyTypes:
  - Ingress

#Uma regra que bloqueia TUDO de Ingress (Entrada) como Egress (Saída)
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-ingress-egress
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress