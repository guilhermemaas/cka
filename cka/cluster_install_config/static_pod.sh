#Pods estáticos são gerenciados diretamente pelo kubelet
#Não envolve o scheduler, é o kubelet que toma conta dele...
#São os podes onde os manifestos estão em:
ls -lha /etc/kubernetes/manifests | grep yaml
etc, kube-api-server, kube-controller-manager, kube-scheduler

#Quando dá um systemctl status kubelet, tem o path pro arquivo de config:
/var/lib/kubelet/config.yaml

#Na linha "", aponta o diretório com os manifestos dos pods estáticos...
staticPodPath: /etc/kubernetes/manifests

#Então se eu quiser criar um static pod bastaria:
kubectl run nginx-static-pod --image nginx --port 80 --dry-run=client -o yaml >> nginx-static-pod.yaml
cp nginx-static-pod.yaml /etc/kubernetes/manifests/

#Kube-controller - Loops de controle:
# - Quando cria um namespace, vai criar as chaves. 
# - Quando cria um serviço, criar os endpoints.
# - Aumenta o número de réplicas, executar/solicitar mais.

#Kube-scheduler - Pra onde esse pod vai? Verifica os limites do host/namespace, e vê onde os wordkloads
#vão se encaixar melhor.

#Kube-proxy - Criar as regras de firewall (bolo de iptables), vai gerenciar. Vai criar as regras pra
#export os serviços.

#CoreDNS - Servidor interno. Zona interna.

#Ingress Controller - Balanceador HTTP e TCP, conexão/distribuidor para os serviços.
#HTTP camada 7.
#TCP camanda 5?.