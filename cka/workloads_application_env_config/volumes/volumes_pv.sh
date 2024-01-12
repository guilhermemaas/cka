PersistentVolumeClaim
Um PersistentVolumeClaim (PVC) é uma solicitação de armazenamento por um usuário. É semelhante a um pod. Os pods consomem recursos do nó e os PVCs consomem recursos PV.

####pv:
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mongodb-pv
spec:
  capacity:
    storage: 100Mi
  hostPath:
    path: /data-mongodb
  accessModes:
  - ReadWriteOnce

####pvc:
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodb-pvc
spec:
  resources:
    requests:
      storage: 100Mi
  accessModes:
  - ReadWriteOnce
  volumeName: mongodb-pv

################################################
################################################
################################################

Primeiro PVC:
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: primeiroPVC
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
Pra prova:
.spec
accessModes:
accessModes:
- [ReadWriteOnce | ReadOnlyMany | ReadWriteMany]

ReadWriteOnce -- O volume pode ser montado com leitura e escrita(read-write) por um único node.
ReadOnlyMany -- O volume pode ser montado como somente leitura(read-only) por vários node.
ReadWriteMany -- O volume pode ser montado como leitura e escrita(read-write) por vários nodes.
Class:
Determina qual será o storageClass que o PV irá utilizar
storageClassName: "Slow"
Resources:
Como pods, podem solicitar quantidades específicas de um recurso. Nesse caso, a solicitação é para armazenamento.
resources:
  requests:
    storage: 9Gi
volumeName:
Força a utilização específica de um PV
volumeName: primeiroPV
Selector:
Os PVCS podem especificar um "label selector" para filtrar ainda mais o processo para um PV
  selector: [matchLabels  |  matchExpressions]
    matchLabels:
      release: "dev"
    matchExpressions:
      - {key: environment, operator: In, values: [dev]}

matchLabels = O volume deve ter uma label com este valor
matchExpressions = Uma lista de requisitos feita especificando chave, lista de valores e operador que relaciona a chave e os valores. Os operadores válidos incluem In, NotIn, Exists e DoesNotExist.
Pod:
apiVersion: v1
kind: Pod
metadata:
  name: primeiroPODPVC
spec:
  containers:
    - name: nginx
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: primeiroPVC
  volumes:
    - name: primeiroPVC
      persistentVolumeClaim:
        claimName: primeiroPVC


