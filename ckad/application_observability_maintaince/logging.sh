#Stdout, stderror
#A saída dos containers.

kubectl run nginx --image nginx

#Todo o stdout do comando de entrypoint da imagem docker(docker-entrypoint.sh):
kubectl logs nginx
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2024/01/10 12:45:44 [notice] 1#1: using the "epoll" event method
2024/01/10 12:45:44 [notice] 1#1: nginx/1.25.3
2024/01/10 12:45:44 [notice] 1#1: built by gcc 12.2.0 (Debian 12.2.0-14)
2024/01/10 12:45:44 [notice] 1#1: OS: Linux 5.10.16.3-microsoft-standard-WSL2
2024/01/10 12:45:44 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2024/01/10 12:45:44 [notice] 1#1: start worker processes
2024/01/10 12:45:44 [notice] 1#1: start worker process 32
2024/01/10 12:45:44 [notice] 1#1: start worker process 33
2024/01/10 12:45:44 [notice] 1#1: start worker process 34
2024/01/10 12:45:44 [notice] 1#1: start worker process 35
2024/01/10 12:45:44 [notice] 1#1: start worker process 36
2024/01/10 12:45:44 [notice] 1#1: start worker process 37
2024/01/10 12:45:44 [notice] 1#1: start worker process 38
2024/01/10 12:45:44 [notice] 1#1: start worker process 39
2024/01/10 12:45:44 [notice] 1#1: start worker process 40
2024/01/10 12:45:44 [notice] 1#1: start worker process 41
2024/01/10 12:45:44 [notice] 1#1: start worker process 42
2024/01/10 12:45:44 [notice] 1#1: start worker process 43

#Pegar a última execução
kubectl logs nginx -p #Antes do último restart.

#Pegar logs pelo crictl:
export CONTAINER_RUNTIME_ENDPOINT=unix:///run/containerd/containerd.sock

crictl ps -a
crictl pods 

#Monitoring -> Recursos que os workloads estão utilizando
#Instalar o metric server.

#Instalar o metric server:
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
#Configurar um bypass, por que os certificados foram auto assinados:
kubectl edit deploy -n kube-system metrics-server

kubectl get po -A


##kubectl top
kubectl top node
kubectl top pod

#verificar qual pod de todos está usando mais recursos:
kubectl top po -A
kubectl top po -n kube-system
kubectl top po kube-apiserver-cka2-controlplane1 -n kube-system
kubectl logs pod2containers -c container1name

