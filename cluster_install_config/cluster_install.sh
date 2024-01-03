###
###SO Configs

#Carregar módulos necessárions no Kernel
modprobe overlay
modprobe br_netfilter

#Criar um arquivo com os módulos que deverão ser carregados com o boot do SO
vim /etc/modules-load.d/k8s.conf
overlay
br_netfilter

#Habilitar parâmetros do SO para iptables/direcionamento de pacotes de rede
vim /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1

#Recarregar os módulos sem precisar reiniciar
sysctl --system

###
###Runtime: Containerd
apt update
apt install containerd 
#Obs.: É instalado o runc também.

#Criar arquivo de configuração do containerd:
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl status containerd

###
###k8s components:
kubeadm: the command to bootstrap the cluster.
kubelet: the component that runs on all of the machines in your cluster and does things like starting pods and containers.
kubectl: the command line util to talk to your cluster.

#Ubuntu 20.04:
apt-get update && apt-get install -y apt-transport-https ca-certificates curl
mkdir -p /etc/apt/keyrings/
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y kubeadm kubelet kubectl

#Configurar o kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#Instalar a versão 25, pra depois atualizar pra 29:
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.25/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.25/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-cache madison kubelet ou kubeadm ou kubectl
apt install kubelet=1.25.16-1.1 kubeadm=1.25.16-1.1 kubectl=1.25.16-1.1

#Iniciar o cluster
kubeadm init

#Startar/veriificar o status do kubelet
systemctl status kubelet

#comando pra dar join de um nó no cluster:
kubeadm token create --print-join-command
kubeadm join 192.168.1.106:6443 --token mncnsa.bwbrzq28lbzpstgs --discovery-token-ca-cert-hash sha256:0a644c3ab5c50f3b80e0423ddd28ee6ff9cd325e85455d5df4bf909172b7709c

#Instalar um CNI:
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

