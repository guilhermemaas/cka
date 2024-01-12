#Diferente do limit range, que é quanto os pods podem usar de:
- CPU
- Memória
- Ephemeral Storage

#Já no Resource Quota definimos o TOTAL que um Namespace poderá alocar.
Limit e Request de:
- CPU
- Memória
- Ephemeral Storage
- Quantidade de Secrets, Persistent Volume Clain (pvc), Configmap, pods

kubectl apply quota.yaml

kubectl apply -f nginx-limit-quota.yaml
Error from server (Forbidden): error when creating "nginx-limit-quota.yaml": pods "nginx-limit-quota" is forbidden: exceeded quota: ns-quota, requested: cpu=2, used: cpu=200m, limited: cpu=1

➜  resources_limitrange_quotas git:(main) ✗ kubectl delete pod nginx2
pod "nginx2" deleted
➜  resources_limitrange_quotas git:(main) ✗ kubectl run nginx2 --image nginx
pod/nginx2 created
➜  resources_limitrange_quotas git:(main) ✗ kubectl run nginx3 --image nginx
pod/nginx3 created
➜  resources_limitrange_quotas git:(main) ✗ kubectl run nginx4 --image nginx
pod/nginx4 created
➜  resources_limitrange_quotas git:(main) ✗ kubectl get quota
NAME       AGE   REQUEST                                         LIMIT
ns-quota   22m   cpu: 1700m/10, memory: 128Mi/1Gi, pods: 10/10
➜  resources_limitrange_quotas git:(main) ✗ kubectl run nginx5 --image nginx
Error from server (Forbidden): pods "nginx5" is forbidden: exceeded quota: ns-quota, requested: pods=1, used: pods=10, limited: pods=10

#Criar quota via kubectl
kubectl create quota quota2 --hard pod=2,cpu=2,memory=1Gi --dry-run=client -o yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  creationTimestamp: null
  name: quota2
spec:
  hard:
    cpu: "2"
    memory: 1Gi
    pod: "2"
status: {}