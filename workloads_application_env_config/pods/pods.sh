#Um amontoado de cgroups e linux namespaces onde o container roda isolado como um processo
#único, onde o kubernetes gerencia.

#container sempre é lista, por que eu posso ter um ou mais.

#Ver documentação
kubectl explain pod
kubectl explain pod.spec
kubectl explain pod.spec.container

#Criar um pod da meneira mais rápida pssível
kubectl run nginx --image nginx --env teste=teste, total=10
kubectl run nginx --image nginx --env teste=teste, total=10
kubectl run nginx --image nginx --env teste=teste, total=10
kubectl run nginx --image nginx --env teste=teste --port 80 --dry-run=client -o yaml
kubectl run sleep --image busybox -o yaml --dry-run=client -- sleep 1000 > sleep.yaml

#Editar um pod:
kubectl edit pod nginx #Trocar imagens e poucas coisas mais

#Fazer update do pod:
kubectl get pod meu-pod -o yaml > meu-pod.yml
kubectl replace -f meu-pod.yml --force

#Burlar o gracefull shutdown
kubectl delete pod sleep --force --grace-period=0
kubectl replace -f sleep.yaml --force --grace-period=0

#Quando tenho 2 containers em um pod:
kubectl exec -it pod_name -c nome_container comando

#Exemplo 1 container nginx, 1 container redis
kubectl exec -it nginx2 -c nginx2 bash
curl telnet://localhost:6379
#PING
#+PONG

#Vão rodar no mesmo nó, pois vão compartilhar camada de red, e disco (Volumes)