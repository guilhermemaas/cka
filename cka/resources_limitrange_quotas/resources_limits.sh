#Capacidade do nó
kubectl describe node xpto

#Capacidade
Capacity:
  cpu:                12
  ephemeral-storage:  263174212Ki
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             16342704Ki
  pods:               110

#Quanto está disponível para o k8s usar
Allocatable:
  cpu:                12
  ephemeral-storage:  263174212Ki
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             16342704Ki
  pods:               110

#Quanto está usando:
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests     Limits
  --------           --------     ------
  cpu                1950m (16%)  2100m (17%)
  memory             1090Mi (6%)  2438Mi (15%)
  ephemeral-storage  0 (0%)       0 (0%)
  hugepages-1Gi      0 (0%)       0 (0%)
  hugepages-2Mi      0 (0%)       0 (0%)


#Por Pod:
Non-terminated Pods:          (26 in total)
  Namespace                   Name                                                CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                                                ------------  ----------  ---------------  -------------  ---
  argco-101                   python-robert-test-6894bf7f8-cd8mk                  500m (4%)     1 (8%)      400Mi (2%)       1Gi (6%)       2d2h
  argco-101                   python-robert-test-6894bf7f8-v9gmc                  500m (4%)     1 (8%)      400Mi (2%)       1Gi (6%)       2d2h
  argocd                      argocd-application-controller-0                     0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d2h
  argocd                      argocd-applicationset-controller-dc5c4c965-2mlwg    0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d2h
  argocd                      argocd-dex-server-9769d6499-tvzdm                   0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d2h
  argocd                      argocd-notifications-controller-db4f975f8-ntbqf     0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d2h
  argocd                      argocd-redis-b5d6bf5f5-qjs2b                        0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d2h
  argocd                      argocd-repo-server-579cdc7849-52nbw                 0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d2h
  argocd                      argocd-server-557c4c6dff-mxtxb                      0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d2h
  day1                        nginx                                               0 (0%)        0 (0%)      0 (0%)           0 (0%)         4d14h
  default                     deploy-1-78675855b7-5rsth                           0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d14h
  default                     deploy-1-78675855b7-5vckd                           0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d14h
  default                     deploy-1-78675855b7-fpqjl                           0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d14h
  default                     deploy-1-78675855b7-gzgsp                           0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d14h
  default                     deploy-1-78675855b7-hqcs7                           0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d14h
  default                     deploy-1-78675855b7-v56f7                           0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d14h
  default                     nginx                                               0 (0%)        0 (0%)      0 (0%)           0 (0%)         25h
  kube-system                 coredns-5d78c9869d-hx72g                            100m (0%)     0 (0%)      70Mi (0%)        170Mi (1%)     142d
  kube-system                 coredns-5d78c9869d-m959b                            100m (0%)     0 (0%)      70Mi (0%)        170Mi (1%)     142d
  kube-system                 etcd-cka-control-plane                              100m (0%)     0 (0%)      100Mi (0%)       0 (0%)         142d
  kube-system                 kindnet-lx5tx                                       100m (0%)     100m (0%)   50Mi (0%)        50Mi (0%)      142d
  kube-system                 kube-apiserver-cka-control-plane                    250m (2%)     0 (0%)      0 (0%)           0 (0%)         142d
  kube-system                 kube-controller-manager-cka-control-plane           200m (1%)     0 (0%)      0 (0%)           0 (0%)         142d
  kube-system                 kube-proxy-576dj                                    0 (0%)        0 (0%)      0 (0%)           0 (0%)         142d
  kube-system                 kube-scheduler-cka-control-plane                    100m (0%)     0 (0%)      0 (0%)           0 (0%)         142d
  local-path-storage          local-path-provisioner-6bc4bddd6b-77hkl             0 (0%)        0 (0%)      0 (0%)           0 (0%)         142d


#Unidades de CPU:
1vcpu = 1000m
0.5vcpu = 0.5 ou 500m

#Memória
1Gi, 512Mi


###
#Requests and Limits:
Requests: Quantidade de recurso que vai reservar de CPU, Memória e Efemeral Storage (Disco temporário do pod). Mínimo pra subir.
Limits: O limite que o objeto vai poder utilizar. Não pode ultrapassar.

Se chegar no limite de memória, mata e reinicia.
Se chegar no limite de CPU, enfileira os processos. + Lento.

#Obs.:
Eu consigo colocar um limit maior do que o meu cluster/nó possui.
Mas não request...

Se colocar o limit mair, o que acontece é que o pod vai usar o que puder da máquina, sem limites.

#Lab1
Colocar limit maior que o Cluster tem e validar resultado. (POD)
Pod Subiu:
  Limits:
      cpu:     15
      memory:  512Mi
    Requests:
      cpu:        200m
      memory:     256Mi


#Lab2
colocar request maior que o Cluster tem e validar o resultado. (POD)

Não subiu, o scheduler não alocou recursos para o pod:
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  11s   default-scheduler  0/1 nodes are available: 1 Insufficient memory. preemption: 0/1 nodes are available: 1 No preemption victims found for incoming pod..