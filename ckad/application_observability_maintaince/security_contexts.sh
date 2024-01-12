#é uma forma de configurar previlégios tanto no pod, quanto no container:
- Configurar userid, groupid
- fsgroup diferente do que tá na imagem do container
- um perfil do selinux
- um perfil previlegiado ou não
- capabilities, permissões especiais pra interagir com o kernel do linux
- habilitar ou desabilitar o escalonamento de recursos
- deixar o filesystem como somente leitura

#Lab1
#Alterar uid, gid, groups pra valores customizados:
kubectl run ubuntu --image ubuntu --dry-run=client -o yaml -- sleep 1d >> pod.yaml

kubectl exec -it ubuntu -- bash
root@ubuntu:/# id
uid=0(root) gid=0(root) groups=0(root)
#PODE ser configurado no spec do POD, ou no CONTAINER



kubectl replace -f pod.yaml --force --grace-period 0

kubectl exec -it ubuntu -- id
uid=1000 gid=2000 groups=2000,3000

kubectl exec -it ubuntu -- bash
groups: cannot find name for group ID 2000
groups: cannot find name for group ID 3000

#Normal, por que não foram criados no momento do build da imagem do container.

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: ubuntu
  name: ubuntu
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 2000
    fsGroup: 3000
  containers:
  - args:
    - sleep
    - 1d
    image: ubuntu
    name: ubuntu
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

#Lab2
#Alterar as capabilities (Obs.: esse é no contexto do container e não do pod)
#Se eu especificar algo no contexto do container, vai sobrescrever o que foi especificado no spec do pod

kubectl exec -it ubuntu -- bash
root@ubuntu:/# 
root@ubuntu:/#
root@ubuntu:/# date 
Wed Jan 10 16:52:51 UTC 2024
root@ubuntu:/# date --set="18:00:00"
date: cannot set date: Operation not permitted
Wed Jan 10 18:00:00 UTC 2024
root@ubuntu:/# hostname teste
hostname: you must be root to change the host name
root@ubuntu:/#

#Por default o pod não tem capabilities suficientes, para trocar o horário e o hostname, por exemplo.

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: ubuntu
  name: ubuntu
spec:
#  securityContext:
#    runAsUser: 1000
#    runAsGroup: 2000
#    fsGroup: 3000 #O que é fsgroup
  containers:
  - args:
    - sleep
    - 1d
    image: ubuntu
    name: ubuntu
    resources: {}
    securityContext:
      capabilities:
        add:
        - SYS_TIME
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

#Do mesmo jeito que se pode adicionar capabilities, pode dar um drop, pra deixar ainda mais restritivo.

kubectl exec -it ubuntu -- bash
root@ubuntu:/# date
Wed Jan 10 17:05:10 UTC 2024
root@ubuntu:/# date --set="18:00:00"
Wed Jan 10 18:00:00 UTC 2024
root@ubuntu:/# date
Wed Jan 10 18:00:02 UTC 2024
root@ubuntu:/# exit
exit

#Lab2
#Container previlegiado:
#Basicamente tá liberando todas as cabapilities

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: ubuntu
  name: ubuntu
spec:
#  securityContext:
#    runAsUser: 1000
#    runAsGroup: 2000
#    fsGroup: 3000 #O que é fsgroup
  containers:
  - args:
    - sleep
    - 1d
    image: ubuntu
    name: ubuntu
    resources: {}
    securityContext:
      privileged: true
    #  capabilities:
    #    add:
    #    - SYS_TIME
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

kubectl replace -f pod.yaml --force --grace-period 0
pod/ubuntu replaced
root@cka2-controlplane1:/home/gmaas/exercicios-security-contexts# kubectl exec -it ubuntu -- bash
root@ubuntu:/# date
Wed Jan 10 17:15:50 UTC 2024
root@ubuntu:/# date --set="18:00:00"
Wed Jan 10 18:00:00 UTC 2024
root@ubuntu:/# date
Wed Jan 10 18:00:01 UTC 2024
root@ubuntu:/# hostname teste
root@ubuntu:/# hostname
teste
root@ubuntu:/#

#Lab3
#Criar um container read only
#Deixar o pod como imutável
#Só vou ter arquivos passiveis de alteração se colocar um volume externo.

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: ubuntu
  name: ubuntu
spec:
  containers:
  - args:
    - sleep
    - 1d
    image: ubuntu
    name: ubuntu
    resources: {}
    securityContext:
      readOnlyRootFilesystem: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

kubectl exec -it ubuntu -- bash
root@ubuntu:/# > teste.txt
bash: teste.txt: Read-only file system
root@ubuntu:/#
