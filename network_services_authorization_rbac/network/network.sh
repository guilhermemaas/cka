#Cluster Info
kubectl cluster-info

#Dump
kubectl cluster-info dump

#Pegar a faixa de IP destinada para os services:
kubectl cluster-info dump | grep service-cluster-ip-range
                            "--service-cluster-ip-range=10.96.0.0/16",

#Subnet: 255.255.0.0
#Usable Addresses: 65534

#Rede padrão do weavenet:
kubectl cluster-info dump | grep 10.44.0.0/14
INFO: 2024/01/02 20:37:41.333615 adding entry 10.44.0.0/14 to weaver-no-masq-local of 0

#Verificar o IP de um pod
kubectl get po -o wide