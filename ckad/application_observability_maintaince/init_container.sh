#Serve pra modificar ou criar algum arquivo de config por exemplo.
#Se tiver algum erro no init container, o principal(ais) também não vai subir. Vai dar algo como "Init:CrashLoopBackOff"

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: init
  name: init
spec:
  containers:
  - image: nginx
    name: init
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html
  initContainers:
  - name: html-editor
    image: busybox
    command: ["sh", "-c", "echo InitContainer > /html/index.html"]
    volumeMounts:
    - name: html
      mountPath: /html
  volumes:
  - name: html
    emptyDir: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always

kubectl get po -o wide
NAME                    READY   STATUS    RESTARTS   AGE     IP          NODE         NOMINATED NODE   READINESS GATES
blue-5c4d88f686-v7d2j   1/1     Running   0          156m    10.32.0.8   cka2-node1   <none>           <none>
ingress-pod-1           1/1     Running   0          26h     10.32.0.2   cka2-node1   <none>           <none>
ingress-pod-2           1/1     Running   0          26h     10.32.0.3   cka2-node1   <none>           <none>
ingress-pod-3           1/1     Running   0          24h     10.32.0.5   cka2-node1   <none>           <none>
init                    1/1     Running   0          2m51s   10.32.0.6   cka2-node1   <none>           <none>

curl 10.32.0.6
InitContainer