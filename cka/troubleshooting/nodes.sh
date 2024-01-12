#Lab1
watch -n 0 kubectl get no
systemctl stop kubelet

#Todas as configs do kubelet:
# Note: This dropin only works with kubeadm and kubelet v1.11+
#vim /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf #Path pro config do systemctl do kubelet
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
# This is a file that "kubeadm init" and "kubeadm join" generates at runtime, populating the KUBELET_KUBEADM_ARGS variable dynamically
EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
# This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably, the user should use
# the .NodeRegistration.KubeletExtraArgs object in the configuration files instead. KUBELET_EXTRA_ARGS should be sourced from this file.
EnvironmentFile=-/etc/default/kubelet
ExecStart=
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS

#Alterado algo pra dar erro no config do systemctl
systemctl daemon-reload

#Ver logs
journalctl -u kubelet

Jan 05 20:39:24 cka2-controlplane1 systemd[44505]: kubelet.service: Failed to execute command: No such file or directory
Jan 05 20:39:24 cka2-controlplane1 systemd[44505]: kubelet.service: Failed at step EXEC spawning /usr/bin/kubelet13232: No such file or directory



####
#Lab2
#Quebrar o config do kubelet 
vim /var/lib/kubelet/config.yaml
journalctl -u kubelet | tail -n 20000 | grep -i error

###
#Lab3
#Quebrar as vars de ambiente do containerd
vim /var/lib/kubelet/kubeadm-flags.env

journalctl -u kubelet

Channel #1 SubChannel #2] grpc: addrConn.createTransport failed to connect to {Addr: "/var/run/containerd/containerd1.sock", ServerName: "%2Fvar%2Frun%2Fcontainerd%2Fcontainerd1.sock", }. Err: connection err>
led" err="failed to run Kubelet: validate service connection: validate CRI v1 runtime API for endpoint \"unix:///var/run/containerd/containerd1.sock\": rpc error: code = Unavailable desc = connection error: >
=1/FAILURE

Como encontrar o socket do containerd?
systemctl status containerd
-address /run/containerd/containerd.sock

ou vim /etc/containerd/
[grpc]
  address = "/run/containerd/containerd.sock"


#Outro componente é o Kube Proxy
#é um daemonset, ou seja, vai suber em cada node.

###
#Lab4
#kube proxy
kubectl run nginx --image nginx
kubectl expose pod nginx --port 65535 --target-port 80
kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)     AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP     54m
nginx        ClusterIP   10.109.61.108   <none>        65535/TCP   8s

curl 10.109.61.108:65535

kubectl get ds 
kubectl edit ds kube-proxy -n kube-system
#Alterado qualquer coisa pra quebrar...
#matado os 3 pods, subiram 3 novos com erro:
kube-proxy-dh776                             0/1     RunContainerError   1 (4s ago)    5s
kube-proxy-g5q89                             0/1     RunContainerError   1 (3s ago)    5s
kube-proxy-xn692                             0/1     RunContainerError   3 (12s ago)   51s

#Subir outro pod, e export outro svc
kubectl run nginx1 --image nginx
kubectl expose pod nginx1 --port 81 --target-port 80
kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)     AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP     61m
nginx        ClusterIP   10.109.61.108   <none>        65535/TCP   6m53s
nginx1       ClusterIP   10.106.14.92    <none>        81/TCP      4s

curl 10.106.14.92:81 #Timeout

#Usa o kubeproxy, como ele tá parado... Ele que cria as regras de IPtables pra fazer a comunicação entre svc e pdo, balancemanto, etc

#Ajustar
kubectl edit ds kube-proxy -n kube-system

#Voalá:
curl 10.106.14.92:81
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>

#Kubectl events
kubectl events

#Cluster infos
kubectl cluster-info