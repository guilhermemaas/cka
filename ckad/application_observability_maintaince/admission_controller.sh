#Um trecho de código/Middleware que vai iterceptar uma chamada para o API Server
#antes da persistência desse objeto
#Só que antes disso a gente precisa ser autenticada e autorizada com as permissões
#Vai olhar o request, pra validar um objeto, alterar algum objeto...
#Podem limitar a alteração de um objeto via api

##### O LimitRange é um admission Controller por exemplo.
#Valida o manifesto antes de ser armazendo no etcd

#tem que alterar o /etc/kubernetes/manifests/kube-apiserver.yaml
spec:
  containers:
  - command:
    - kube-apiserver
    - --advertise-address=192.168.1.103
    - --allow-privileged=true
    - --authorization-mode=Node,RBAC
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
    - --enable-admission-plugins=NodeRestriction,LimitRanger,AlwaysPullImages,NamespaceAutoProvision #-> Add plugin

#O NamespacesAutoProvision, por exemplo:
kubectl run nginx --image nginx -n naoexiste
#Vai criar o ns naoexiste

#Como verificar quiais Admissions Controllers estão ativos:
#1 - Olhando no manifesto:
cat /etc/kubernetes/manifests/kube-apiserver.yaml

#2 - Pelo ps aux | grep plugins
root@cka2-controlplane1:/home/gmaas# ps aux | grep plugins
root       17258  7.4  6.6 1487916 266720 ?      Ssl  13:34   0:21 kube-apiserver 
--advertise-address=192.168.1.103 --allow-privileged=true --authorization-mode=Node,RBAC 
--client-ca-file=/etc/kubernetes/pki/ca.crt --enable-admission-plugins=NodeRestriction,LimitRanger,AlwaysPullImages,NamespaceAutoProvision
