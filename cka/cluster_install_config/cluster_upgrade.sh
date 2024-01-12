#Drain só faz quando vai atualizar um nó, no control plane não.

#Upgrade do control plane, 1.25 > 1.26

apt-get update && apt-get install -y apt-transport-https ca-certificates curl
mkdir -p /etc/apt/keyrings/
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.26/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.26/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y kubeadm kubelet kubectl

apt install kubeadm=1.26.12-1.1

#Travar o pacote do kubeadm
apt-mark hold kubeadm

#kubeadm upgrade plan -> para verificar o que é necessário/vai ser atualizado.
kubeadm upgrade plan

#verificar se precisa de alguma alteração manual. O mínimo que vai mostrar é que precisa atualizar o kubelet.
kubeadm upgrade apply v1.26.12

#Validar versão do api-server:
kubectl get po -n kube-system kube-apiserver-cka-controlplane1 -o yaml | grep -i image:

#atualizar o kubelete
apt install kubelet=1.26.12-1.1

#Reiniciar após instalar a versão nova do kubelet
systemctl daemon reload
systemctl restart kubelet

#atualizar o kubectl 
apt install kubectl=1.26.12-1.1

#Travar a versão do kubelet
apt-mark hold kubelet

####
#Atualização de um nó somente:

#Fazer o drain, para tirar a carga e jogar pra outros nós (rodar no control plane)
kubectl drain cka-node1 --ignore-daemonsets
apt install kubeadm=1.26.12-1.1

#Fazer o upgrade do kubeadm
kubeadm upgrade node

#Atualizar o kubelet
apt install kubeadm=1.26.12-1.1
systemctl daemon reload
systemctl restart kubelet 

#Atualizar o kubectl
apt install kubectl=1.26.12-1.1

#Liberar o node do drain:
kubectl uncordon cka-node1