PV e PVC
1 Crie um Persistent Volume com as seguintes características:
nome: ex1-pv
tipo: HostPath
O volume pode utilizar o diretório de sua preferencia
storage: 2Gi
AccessModes: ReadWriteOnce

apiVersion: v1
kind: PersistentVolume
metadata:
  name: ex1-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  hostPath:
    path: /data


######################################################################################################
######################################################################################################

2 Crie um Persistent Volume Claim com as seguintes características:
nome: task1-pvc
Storage: 1Gi
AccessModes: ReadWriteOnce
Deve utilizar o PV: ex1-pv

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task1-pvc
spec:
  volumeMode: Filesystem
  resources:
    requests:
      storage: 1Gi
  accessModes:
  - ReadWriteOnce

######################################################################################################
######################################################################################################

3 Crie um POD chamando com as seguintes características:
nome: ex-pod-pvc
image: nginx
Utilize o PVC criado na exercício anterior: task1-pvc
Monte o volume no path: /data

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: ex-pod-pvc
  name: ex-pod-pvc
spec:
  containers:
  - image: nginx
    name: ex-pod-pvc
    resources: {}
    volumeMounts:
    - name: volume-pvc
      mountPath: /data
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: volume-pvc
    persistentVolumeClaim:
      claimName: task1-pvc
status: {}    

######################################################################################################
######################################################################################################

4 Crie um POD chamando com as seguintes características:
nome: redis
image: redis
Utilizar um volume do tipo: emptyDyr
Monte o volume no path: /data/redis

apiVersion: v1
kind: Pod
metadata:
  name: redis
  labels:
    app: redis
spec:
  containers:
  - name: redis
    image: redis
    volumeMounts:
    - name: empty-dir
      mountPath: /data/redis
  volumes:
  - name: empty-dir
    emptyDir:
      sizeLimit: 1Gi
    

######################################################################################################
######################################################################################################

5 Crie um Persistent Volume com as seguintes características:
nome: html-index-pv
tipo: HostPath
O volume pode utilizar o diretório de sua preferencia
storage: 100Mi
AccessModes: ReadWriteOnce

apiVersion: v1
kind: PersistentVolume
metadata:
  name: html-index-pv
  labels:
    app: html-index
spec:
  capacity:
    storage: 100Mi
  accessModes:
  - ReadWriteOnce
  hostPath:
    path: /html
  
######################################################################################################
######################################################################################################

6 Criar um Persistent Volume Claim com as seguintes características:
nome: html-index-pvc
Storage: 100Mi
AccessModes: ReadWriteOnce
Deve utilizar o PV: html-index-pv

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: html-index-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
  selector:
    matchLabels:
      app: html-index

######################################################################################################
######################################################################################################

7 Crie um POD chamando com as seguintes características:
Nome: nginx-html
container 1
nome: nginx-html
image: Nginx
utilizar o PVC: html-index-pvc
Monte o volume no path /usr/share/nginx/html
container 2
nome: busybox
image: busybox
command: ["/bin/sh", "-c", "while true; do date >> /html/index.html; sleep 1; done"]
utilizar o PVC: html-index-pvc
Monte o volume no path /html

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx-html
  name: nginx-html
spec:
  containers:
  - image: nginx
    name: nginx-html
    resources: {}
    volumeMounts:
    - name: html-index-pvc
      mountPath: /usr/share/nginx/html
  - name: html-index-pvc
    image: busybox
    name: busybox
    command:
    - "/bin/sh"
    - "-c"
    - "while true; do date >> /html/index.html; sleep 1; done"
    resources: {}
    volumeMounts:
    - name: html-index-pvc
      mountPath: /html
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: html-index-pvc
    persistentVolumeClaim:
      claimName: html-index-pvc

######################################################################################################
######################################################################################################

8 Execute um curl no pod criado anteriormente e salve a saída em /tmp/ex8.txt



######################################################################################################
######################################################################################################

9 Crie um Persistent Volume com as seguintes características:
nome: mysql-pv
tipo: HostPath
O volume pode utilizar o diretório de sua preferencia
storage: 1Gi
RetainPolicy: Retain
AccessModes: ReadWriteOnce

curl 10.32.0.5 >> /tmp/ex8.txt
cat /tmp/ex8.txt
Sun Jan  7 20:15:24 UTC 2024
Sun Jan  7 20:15:25 UTC 2024
Sun Jan  7 20:15:26 UTC 2024
Sun Jan  7 20:15:27 UTC 2024

######################################################################################################
######################################################################################################

10 Criar um Persistent Volume Claim com as seguintes características:
nome: mysql-pvc
Storage: 500Mi
AccessModes: ReadWriteOnce
Deve utilizar o PV: mysql-pv

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
spec:
  resources:
    requests:
      storage: 500Mi
  accessModes:
  - ReadWriteOnce
  selector:
    matchLabels:
      db: mysql

######################################################################################################
######################################################################################################

11 Crie um POD chamando com as seguintes características:
nome: mysql
image: mysql:5.6
utilizar o PVC mysql-pvc
Monte o volume no path: /var/lib/mysql

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: mysql
  name: mysql
spec:
  containers:
  - image: mysql:5.6
    name: mysql
    resources: {}
    volumeMounts:
    - name: mysql-data
      mountPath: /var/lib/mysql
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: mysql-data
    persistentVolumeClaim:
      claimName: mysql-pvc
status: {}

######################################################################################################
######################################################################################################

Agora investigue o status do pod, e verifique o motivo do erro

kubectl logs -p mysql
2024-01-07 20:50:57+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 5.6.51-1debian9 started.
2024-01-07 20:50:57+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
2024-01-07 20:50:57+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 5.6.51-1debian9 started.
2024-01-07 20:50:57+00:00 [ERROR] [Entrypoint]: Database is uninitialized and password option is not specified
    You need to specify one of the following:
    - MYSQL_ROOT_PASSWORD
    - MYSQL_ALLOW_EMPTY_PASSWORD
    - MYSQL_RANDOM_ROOT_PASSWORD

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: mysql
  name: mysql
spec:
  containers:
  - image: mysql:5.6
    name: mysql
    resources: {}
    volumeMounts:
    - name: mysql-data
      mountPath: /var/lib/mysql
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: "123456789"
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: mysql-data
    persistentVolumeClaim:
      claimName: mysql-pvc
status: {}

######################################################################################################
######################################################################################################

12 Criar um Persistent Volume com as seguintes características:
nome: psql-pv
tipo: HostPath
O volume pode utilizar o diretório de sua preferencia
storage: 100Mi
AccessModes: ReadWriteOnce
RetainPolicy: Delete

apiVersion: v1
kind: PersistentVolume
metadata:
  name: psql-pv
  labels:
    db: psql
spec:
  persistentVolumeReclaimPolicy: Delete
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 100Mi
  hostPath:
    path: /data-psql

######################################################################################################
######################################################################################################

13 Criar um Persistent Volume Claim com as seguintes características:
nome: psql-pvc
Storage: 100Mi
AccessModes: ReadWriteOnce
Deve utilizar o PV: postgres-pv

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: psql-pvc
  labels:
    db: psql
spec:
  selector:
    matchLabels:
      db: psql
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi

######################################################################################################
######################################################################################################

14 Crie um POD chamando com as seguintes características:
nome: postgres
image: postgres:11
utilizar o PVC postgres-pvc
Monte o volume no path: /var/lib/postgresql/data

Agora investigue o status do pod, e verifique o motivo do erro

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: postgres
  name: postgres
spec:
  containers:
  - image: postgres:11
    name: postgres
    resources: {}
    volumeMounts:
    - name: data-postgresql
      mountPath: /var/lib/postgresql/data
    env:
    - name: POSTGRES_PASSWORD
      value: "postgres"
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: data-postgresql
    persistentVolumeClaim:
      claimName: psql-pvc

######################################################################################################
######################################################################################################

15 Crie um POD chamando com as seguintes características:
nome: nginx-empty
image: nginx
Utilizar um volume do tipo emptyDyr
nome: nginx-storage
path: /data/nginx

apiVersion: v1
kind: Pod
metadata:
  name: nginx-empty
spec:
  containers:
  - name: nginx
    image: nginx:latest
    volumeMounts:
    - name: nginx-storage
      mountPath: /data/nginx
  volumes:
  - name: nginx-storage
    emptyDir:
      sizeLimit: 50Mi

######################################################################################################
######################################################################################################

16 Criar um Persistent Volume com as seguintes características:
nome: varlog-pv
tipo: HostPath
O volume pode utilizar o diretório de sua preferencia
storage: 500Mi
AccessModes: ReadWriteOnce

apiVersion: v1
kind: PersistentVolume
metadata:
  name: varlog-pv
spec:
  capacity:
    storage: 500Mi
  hostPath:
    path: /log
  accessModes:
  - ReadWriteOnce

######################################################################################################
######################################################################################################

17 Criar um Persistent Volume Claim com as seguintes características:
nome: varlog-pvc
Storage: 500Mi
AccessModes: ReadWriteOnce
Deve utilizar o PV: varlog-pv

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: varlog-pvc
  labels:
    log: log
spec:
  resources:
    requests:
      storage: 500Mi
  accessModes:
  - ReadWriteOnce
  selector:
    matchLabels:
      log: log

######################################################################################################
######################################################################################################

18 Crie um POD com 3 containers chamando com as seguintes características: 
Nome: logger
Container 1:
nome: logger
image: busybox
args:
   - /bin/sh
   - -c
   - >
     i=0;
     while true;
     do
       echo "$i: $(date)" >> /var/log/fixo.log;
       echo "$(date) CACHE $i" >> /cache/cache.log;
       i=$((i+1));
       sleep 1;
     done  
Volumes:
utilizar o PVC varlog-pvc
Monte o volume no path: /var/log/
utilizar um emptyDyr
Monte o volume no path: /cache
Container 2:

nome: logger-cache
image: busybox
vol-empty
tipo: emptyDyr
utilizar o mesmo emptyDyr do container anterior
Monte o volume no path: /cache
* command: ["/bin/sh","-c", "tail -f /cache/cache.log"]
Container 3:

nome: logger-pvc
image: busybox
utilizar o PVC varlog-pvc
Monte o volume no path: /var/log/nginx
* command: ["/bin/sh","-c", "tail -f /var/log/fixo.log"]


Agora investigue o status do pod, e verifique o motivo do erro e o corrija =)

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: logger
  name: logger
spec:
  containers:
  - image: busybox
    name: logger
    resources: {}
    args:
      - /bin/sh
      - -c
      - >
        i=0;
        while true;
        do
          echo "$i: $(date)" >> /var/log/fixo.log;
          echo "$(date) CACHE $i" >> /cache/cache.log;
          i=$((i+1));
          sleep 1;
        done
    volumeMounts:
    - name: log
      mountPath: /var/log
    - name: cache
      mountPath: /cache
  - image: busybox
    name: logger-cache
    resources: {}
    command: ["/bin/sh", "-c", "tail -f /cache/cache.log"]
    volumeMounts:
    - name: cache
      mountPath: /cache
  - image: busybox
    name: logger-pvc
    resources: {}
    volumeMounts:
    - name: log
      mountPath: /var/log/
    command:
    - "bin/sh"
    - "-c"
    - "tail -f /var/log/fixo.log"
  volumes:
  - name: log
    persistentVolumeClaim:
      claimName: varlog-pvc
  - name: cache
    emptyDir:
      sizeLimit: 10Mi
  dnsPolicy: ClusterFirst
  restartPolicy: Always

######################################################################################################
######################################################################################################

19 Crie um POD chamando com as seguintes características:
nome: nginx-temp-log
image: nginx
Utilizar um volume do tipo: emptyDyr
Monte o volume no path: /var/log/nginx
20 Delete todos os recursos criados anteriormente: PODS,PV,PVCS

apiVersion: v1
kind: Pod
metadata:
  name: nginx-temp-log
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: nginx-log
      mountPath: /var/log/nginx
  volumes:
    - name: nginx-log
      emptyDir:
        sizeLimit: 10Mi