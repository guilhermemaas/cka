#Diretório dos manifestos da instalação do kubernetes:
/etc/kubernetes/manifests
cat etcd.yaml

#Informações importantes para autenticação:
- --listen-client-urls=https://127.0.0.1:2379,https://172.18.0.2:2379

#CA Cert
- --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt

#Cert

- --cert-file=/etc/kubernetes/pki/etcd/server.crt

#key
- --key-file=/etc/kubernetes/pki/etcd/server.key


#Download and install etcdctl se não existir:
cd /tmp
wget https://github.com/etcd-io/etcd/releases/download/v3.5.11/etcd-v3.5.11-linux-amd64.tar.gz
tar -vxzf etcd...tar.gz
cd etcd...tar.gz
cp etcd* /usr/bin/
etcdctl -v

#Passar variáveis de ambiente pro comando de backup
ETCDCTL_API3=3 etcdctl snapshot save --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key /tmp/backup.db

#Como verificar o backup gerado:
etcdctl --write-out=table snapshot status /tmp/backup.db

##RESTORE
ETCDCTL_API=3 etcdctl snapshot restore --data-dir=/var/lib/etcd-backup /tmp/backup2.db

#Essa pasta acima não é a original. Como apontar pra ela?
vim /etc/kubernetes/manifests/etcd.yaml
  volumes:
  - hostPath:
      path: /etc/kubernetes/pki/etcd
      type: DirectoryOrCreate
    name: etcd-certs
  - hostPath:
      path: /var/lib/etcd-backup
      type: DirectoryOrCreate
    name: etcd-data

#Trocar o hostpath.path

systemctl stop kubelet
systemctl start kubelet

#Verificar se os pods voltaram
kubectl get po -A

#Caso tenha algum problema, pode executar usando o etcdctl de dentro do pod:
kubectl exec -it etcd-cka-controlplane1 -n kube-system -- etcdctl snapshot -h
