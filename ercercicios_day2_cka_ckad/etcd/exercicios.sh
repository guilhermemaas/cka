########ETCD
1 Crie um diretório chamado backup.
mkdir backup
wget https://github.com/etcd-io/etcd/releases/download/v3.5.11/etcd-v3.5.11-linux-amd64.tar.gz
tar -vxzf etcd...
chmod +x etcd...

2 Crie um backup do ETCD e o salve-o no diretório backup/snaphost.db
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save backup/snapshot.db

3 Verifique a integridade do Backup
ETCDCTL_API=3 etcdctl --write-out=table snapshot status backup/snapshot.db
Deprecated: Use `etcdutl snapshot status` instead.

+----------+----------+------------+------------+
|   HASH   | REVISION | TOTAL KEYS | TOTAL SIZE |
+----------+----------+------------+------------+
| bc7e77d6 |    99913 |       4679 |      12 MB |
+----------+----------+------------+------------+


4 Crie um pod qualquer
kubectl run nginx-etcd-restore --image nginx

5 Faça o restore do snapshot criado anteriormente e verifique se o pod ainda está criado.
ETCDCTL_API=3 etcdctl --data-dir==/var/lib/etcd snapshot restore backup/snapshot.db
ETCDCTL_API=3 etcdctl snapshot restore --data-dir=/var/lib/etcd backup/snapshot.db

Pior que continou criado.

