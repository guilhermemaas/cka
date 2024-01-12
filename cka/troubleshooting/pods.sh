#Troubleshooting de aplicação/pods
#comando chave:
kubectl describe pod xpto

#Log dos pods
/var/log/pods

#Status de Pending:
- Tá usando recurso mais que o node tem... o Scheduler não vai subir ele. (Request and Limits)

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    resources:
      requests:
        cpu: 20
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}


kubectl apply -f pod.yaml
pod/nginx created
root@cka2-controlplane1:/home/gmaas# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   0/1     Pending   0          2s

kubectl describe pod nginx

"Warning  FailedScheduling  71s   default-scheduler  0/3 nodes are available: 1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }, 2 Insufficient cpu. preemption: 0/3 nodes are available: 1 Preemption is not helpful for scheduling, 2 No preemption victims found for incoming pod.
"


###Lab 2
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    resources: {}
    volumeMounts:
    - name: meu-cm
      mountPath: /data
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: meu-cm
    configMap:
      name: meu-cm

  Type     Reason       Age                From               Message
  ----     ------       ----               ----               -------
  Normal   Scheduled    27s                default-scheduler  Successfully assigned default/nginx to cka2-node2
  Warning  FailedMount  12s (x6 over 28s)  kubelet            MountVolume.SetUp failed for volume "meu-cm" : configmap "meu-cm" not found

kubectl get pod
NAME    READY   STATUS              RESTARTS   AGE
nginx   0/1     ContainerCreating   0          58s
