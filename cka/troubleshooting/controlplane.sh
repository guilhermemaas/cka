Componentes do Control Plane:
Kube API Server: Coração de tudo/Core, a API do Kubernetes, todos os componentes do Control Plane se conversam através da Api Server.
    - Todos os controllers se falam através da api.
    - O kubelet de um node fala com o api server
ETCD: Banco de dados, armazena a persistência do estado do cluster.
    - Sem etcd não tem cluster.

Obs.: Sem esses 2 o cluster não tá de pé.

Kube Controller Manager: Ele fica rodando loopins de controle.
    - Verifica estado dos nós.
    - Tasks scheduladas, se o pod completou a task (Job Controller)
    - Endpoint Controller. 
    - Service Account de Controler responsável por criar os SAs padrão e seus tokens quando se cria um namspace novo.
    - Controlar as réplicas nos nós.

Kube Scheduler: Ele que verificar onde vai ser criado um novo pod. Conforme recursos, labels, limits, etc. Agendar os novos pods
nos nós, leva em consideração hardware, afinidade, etc.

Kubelet: Agente do Kubernetes, ele que garante que o container está rodando no nó, e ele também que sobe os statics pods.

Kube Proxy: Ele que faz a parte de serviço e comunicão entre nós, sem ele não tem balanceamento, e comunicação entre services e nós.

Container Run Time: Cri-o, Containerd

CNI - Container Network interface

DNS - CoreDNS


#Lab1
Provocar falha no ETCD:
#1-
vim /etc/kubernetes/manifests/etcd.yaml
   #alterado o comando que chama o etcd pra etcdx

#2
kubectl get po -> Já não responde

#3 Verificar containers/pods do kubernetes rodando no containerd
crictl pods
crictl ps -a
verificar os containers que morreram (no caso o apiserver)
verificar os logs:

crictl logs ID

Verficado erro de acesso no etcd:
# connection error: desc = "transport: Error while dialing: dial tcp 127.0.0.1:2379: connect: connection refused"
#W0104 22:20:53.245300       1 logging.go:59] [core] [Channel #4 SubChannel #5] grpc: addrConn.createTransport failed to 
#connect to {Addr: "127.0.0.1:2379", ServerName: "127.0.0.1", }. Err: connection error: desc 
#= "transport: Error while dialing: dial tcp 127.0.0.1:2379: connect: connection refused"

#Lab2
root@cka-controlplane1:/home/gmaas# crictl logs 976989a82aad1
E0104 23:36:02.891412   55672 remote_runtime.go:432] "ContainerStatus from runtime service failed" err="rpc error: code = NotFound desc = an error occurred when try to find container \"976989a82aad1\": not found" containerID="976989a82aad1"
FATA[0000] rpc error: code = NotFound desc = an error occurred when try to find container "976989a82aad1": not found


Alterado uma flag no /etc/kubernetes/manifests/kube-api.yaml

Logs do container do kube-api
root@cka-controlplane1:/home/gmaas# crictl logs 976989a82aad1
Error: unknown flag: --flagerrada

#Cada vez que o pod tenta iniciar, esse arquivo é refeito com o último log:
root@cka-controlplane1:/var/log/pods/kube-system_kube-apiserver-cka-controlplane1_9280d53b466edd37504a2630e3aaf1c6/kube-apiserver# cat 19.log
2024-01-04T23:30:41.870770098Z stderr F Error: unknown flag: --flagerrada

#Após ajustar foi necessário reiniciar o kubelet
systemctl stop kubelet
systemctl start kubelet

Não estava nem mais tentando iniciar o container do apiserver...

#Como ver os logs do Kubelet?
journalctl -u kubelet

#Lab 3
Parar o Scheduler
vim /etc/kubernetes/manifests/kube-scheduler.yaml
kube-scheduler-cka-controlplane1            0/1     CrashLoopBackOff   3 (39s ago)    84s

#Obs: o API Server ainda fica de pé, então é possível executar comandos...

crictl ps -a
CONTAINER           IMAGE               CREATED              STATE               NAME                      ATTEMPT             POD ID              POD
d947271ddde5e       9c7ffedd7c6d4       About a minute ago   Exited              kube-scheduler            4   


#Tentar rodar um pod
kubectl run nginx99 --imagem nginx

Pod fica como "Pending...

Em "Events", nenhum...
#Events:                      <none>

#É por que ainda não foi agendado. Ou seja, problema no kube-scheduler!


#Lab 4 Kube-controller
vim /etc/kubernetes/manifests/kube-controller-manager.yaml

Lembrando que o controller manager é responsável por subir e descer réplicas, a api vai cotninuar funcionando, mas se tentar 
alterar o número de réplicas não vai funcionar.

kubectl create deploy nginx98 --image nginx

kubectl create deploy nginx98 --image nginx
deployment.apps/nginx98 created
root@cka-controlplane1:/home/gmaas# kubectl get deploy
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
nginx98   0/1     0            0           4s

kubectl scale deploy nginx98 --replicas 5
deployment.apps/nginx98 scaled


#Lab 5: 
Alterou o IP do control plane, o que fazer no CP e no node?

Control plane:
Atualizar o IP para o novo nos manifestos:
/etc/kubernetes/manifests/
:%s/{oldIPaddress}/{newIPaddress}/gc

Também nos arquivos do diretório /etc/kubernetes/

KUBECONFIG=/etc/kubernetes/admin.conf
kubectl -n kube-system get configmap kubeadm-config -o jsonpath='{.data.ClusterConfiguration}' --insecure-skip-tls-verify > kubeadm.yaml

https://dev.to/aws-builders/securing-kubernetes-api-server-adding-a-new-hostname-or-ip-address-to-kubernetes-api-server-1aej

#Ajustado a config do kubelet no nó worker também...

#Lab 6
Pod sandbox changed, it will be killed and re-created
