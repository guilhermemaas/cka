Network
1 Criar um POD com as seguintes características:
nome: ex-net-1
image: nginx
port: 80

######################################################################################################
######################################################################################################

2 Criar um Service com as seguintes características para o pod criado anteriormente:
nome: svc-net-1
port: 8080
target-port: 80
Tipo: ClusterIP

curl 10.109.182.67:8080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>

apiVersion: v1
kind: Service
metadata:
  name: svc-net-1
spec:
  selector:
    run: ex-net-1
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 80
  type: ClusterIP

######################################################################################################
######################################################################################################

3 Execute um curl para o serviço criado e salve a saída em /tmp/net1.txt

curl 10.109.182.67:8080 >> /tmp/net1.txt

cat /tmp/net1.txt
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>

######################################################################################################
######################################################################################################

4* Criar um POD com as seguintes características:
nome: ex-net-2
image: httpd
port: 80

kubectl get po ex-net-2
NAME       READY   STATUS    RESTARTS   AGE
ex-net-2   1/1     Running   0          3m

######################################################################################################
######################################################################################################

5 Criar um Service com as seguintes características para o pod criado anteriormente:
nome: svc-net-2
port: 80
target-port: 80
Tipo: NodePort

apiVersion: v1
kind: Service
metadata:
  name: svc-net-2
spec:
  selector:
    run: ex-net-2
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: NodePort

#Pra fazer com kubectl
kubectl expose pod ex-net-2 --port 80 --target-port 80 --type NodePort

######################################################################################################
######################################################################################################

6 Execute um curl para o serviço criado e salve a saída em /tmp/net2.txt

curl 10.111.245.24 >> tmp/net2.txt
cat tmp/net2.txt
<html><body><h1>It works!</h1></body></html>

######################################################################################################
######################################################################################################

7 Execute um curl a partir do POD ex-net-1 para o serviço svc-net-2 utilizando DNS

kubectl exec -it ex-net-1 -- curl svc-net-2.default.svc
<html><body><h1>It works!</h1></body></html>

######################################################################################################
######################################################################################################

8 Execute um curl a partir do POD ex-net-2 para o serviço svc-net-1 utilizando DNS

root@ex-net-2:/usr/local/apache2# curl svc-net-1.default.svc:8080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>

######################################################################################################
######################################################################################################

9 Crie um namespace chamado netns

kubectl create ns netns

######################################################################################################
######################################################################################################

10 Criar um POD com as seguintes características:
nome: ns-net-1
image: nginx
port: 80
namespace: netns

kubectl run ns-net-1 --image nginx --port 80 --namespace netns
kubectl get po -n netns
NAME       READY   STATUS    RESTARTS   AGE
ns-net-1   1/1     Running   0          5s

######################################################################################################
######################################################################################################

11 Criar um Service com as seguintes características para o pod criado anteriormente:
nome: svc-nsnet-1
port: 8080
target-port: 80
Tipo: ClusterIP
namespace: netns

apiVersion: v1
kind: Service
metadata:
  name: svc-nsnet-1
  namespace: netns
spec:
  selector:
    run: ns-net-1
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 80
  type: ClusterIP

######################################################################################################
######################################################################################################

12 Execute um curl a partir do POD ns-net-1 para o serviço svc-net-2 utilizando DNS e salve a saída em /tmp/netns.txt

kubectl exec -it ex-net-1 -- curl svc-nsnet-1.netns.svc:8080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>

######################################################################################################
######################################################################################################

13 Altere o svc svc-nsnet-1 para o tipo NodePort e utilize a porta 30010

kubectl get svc -n netns
NAME          TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
svc-nsnet-1   NodePort   10.108.105.55   <none>        30010:30916/TCP   2m52s

######################################################################################################
######################################################################################################

14 Delete todos os pods e services criados anteriormente



######################################################################################################
######################################################################################################

15 Instale o Ingress controller nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/baremetal/deploy.yaml

######################################################################################################
######################################################################################################

16 Criar um POD com as seguintes características:
nome: ingress-pod-1
image: nginx
port: 80

kubectl run ingress-pod-1 --image nginx --port 80
pod/ingress-pod-1 created
root@cka2-controlplane1:/home/gmaas/exercicios-networking# kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
ingress-pod-1   1/1     Running   0          4s

######################################################################################################
######################################################################################################

17 Criar um Service com as seguintes características para o pod criado anteriormente:
nome: ingress-svc-1
port: 80
target-port: 80
Tipo: ClusterIP

apiVersion: v1
kind: Service
metadata:
  name: ingress-svc-1
spec:
  selector:
    run: ingress-pod-1
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP

  kubectl expose po ingress-pod-1 --name ingress-svc-1 --port 80 --target-port 80

######################################################################################################
######################################################################################################

18 Criar um POD com as seguintes características:
nome: ingress-pod-2
image: httpd
port: 80

kubectl run ingress-pod-2 --image httpd --port 80
pod/ingress-pod-2 created
root@cka2-controlplane1:/home/gmaas/exercicios-networking# kubectl get pod
NAME            READY   STATUS    RESTARTS   AGE
ingress-pod-1   1/1     Running   0          11m
ingress-pod-2   1/1     Running   0          5s

######################################################################################################
######################################################################################################

19 Criar um Service com as seguintes características para o pod criado anteriormente:
nome: ingress-svc-2
port: 80
target-port: 80
Tipo: ClusterIP

kubectl get po,svc
NAME                READY   STATUS    RESTARTS   AGE
pod/ingress-pod-1   1/1     Running   0          13m
pod/ingress-pod-2   1/1     Running   0          2m44s

NAME                    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/ingress-svc-1   ClusterIP   10.109.48.28     <none>        80/TCP    11m
service/ingress-svc-2   ClusterIP   10.110.216.155   <none>        80/TCP    5s
service/kubernetes      ClusterIP   10.96.0.1        <none>        443/TCP   3d23h

######################################################################################################
######################################################################################################

20 Verifique todos os ingress class disponíveis

kubectl get ingressclass
NAME    CONTROLLER             PARAMETERS   AGE
nginx   k8s.io/ingress-nginx   <none>       17m

######################################################################################################
######################################################################################################

21 Crie um ingress com as seguintes características:
nome: ingress-ex1
path: /foo
service: ingress-svc-1
path: /bar
service: ingress-svc-2


	Faça um teste utilizando curl para ambos os paths e salve em /tmp/foo.txt e /tmp/bar.txt

	Descubra o motivo dos erros 404 e faça os ajustes necessários. 

curl 192.168.103:30362/foo
^C
root@cka2-controlplane1:/home/gmaas/exercicios-networking# curl 192.168.1.103:30362/foo
<html>
<head><title>503 Service Temporarily Unavailable</title></head>
<body>
<center><h1>503 Service Temporarily Unavailable</h1></center>
<hr><center>nginx</center>
</body>
</html>

######################################################################################################
######################################################################################################

22 Criar um POD com as seguintes características:
nome: ingress-pod-3
image: nginx
port: 80

kubectl run ingress-pod-3 --image nginx --port 80

######################################################################################################
######################################################################################################

23 Criar um Service com as seguintes características para o pod criado anteriormente:
nome: ingress-svc-3
port: 8080
target-port: 80
Tipo: ClusterIP

apiVersion: v1
kind: Service
metadata:
  name: ingress-svc-3
spec:
  selector:
    run: ingress-pod-3
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 80
  type: ClusterIP

kubectl get po,svc
NAME                READY   STATUS    RESTARTS   AGE
pod/ingress-pod-1   1/1     Running   0          58m
pod/ingress-pod-2   1/1     Running   0          47m
pod/ingress-pod-3   1/1     Running   0          75s

NAME                    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/ingress-svc-1   ClusterIP   10.104.87.169    <none>        80/TCP     7m50s
service/ingress-svc-2   ClusterIP   10.110.216.155   <none>        80/TCP     44m
service/ingress-svc-3   ClusterIP   10.96.51.234     <none>        8080/TCP   8s
service/kubernetes      ClusterIP   10.96.0.1        <none>        443/TCP    4d

######################################################################################################
######################################################################################################

24 Edite o ingress criado anteriormente e adicione os seguintes items:
host: meuingres.ckackad.com
path: /
pathType: Prefix
service:  ingress-svc-3

#ERRADO
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-ex1
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /foo
        pathType: Prefix
        backend:
          service:
            name: ingress-svc-1
            port:
              number: 80
      - path: /bar
        pathType: Prefix
        backend:
          service:
            name: ingress-svc-2
            port:
              number: 80
  - host: meuingress.ckackad.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: ingress-svc-3
            port:
              number: 8080


kubectl create ingress ingress-ex --class nginx --rule /foo=ingress-svc-1:80 --rule /bar=ingress-svc-2:80 --rule meuingress.ckackad.com/=ingress-svc-3:8080 --dry-run=client -o yaml >> ingress.yaml


#Dry Run >>> CORRETO
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  creationTimestamp: null
  name: ingress-ex2
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - backend:
          service:
            name: ingress-svc-1
            port:
              number: 80
        path: /foo
        pathType: Exact
      - backend:
          service:
            name: ingress-svc-2
            port:
              number: 80
        path: /bar
        pathType: Exact
status:
  loadBalancer: {}

root@cka2-controlplane1:/home/gmaas/exercicios-networking# kubectl get svc -n ingress-nginx
NAME                                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.107.102.181   <none>        80:30362/TCP,443:31358/TCP   95m
ingress-nginx-controller-admission   ClusterIP   10.98.242.86     <none>        443/TCP                      95m


root@cka2-controlplane1:/home/gmaas/exercicios-networking# curl 192.168.1.103:30362/foo
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.25.3</center>
</body>
</html>
root@cka2-controlplane1:/home/gmaas/exercicios-networking# curl 192.168.1.103:30362/bar
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>404 Not Found</title>
</head><body>
<h1>Not Found</h1>
<p>The requested URL was not found on this server.</p>
</body></html>
root@cka2-controlplane1:/home/gmaas/exercicios-networking#

O que tá acontencendo?

Faltou o rewrite... kubectl edit ingress ingress-ex1

annotations:
  nginx.ingress.kubernetes.io/rewrite-target: /

root@cka2-controlplane1:/home/gmaas/exercicios-networking# curl 192.168.1.103:30362/foo
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
root@cka2-controlplane1:/home/gmaas/exercicios-networking# curl 192.168.1.103:30362/bar
<html><body><h1>It works!</h1></body></html>

######################################################################################################
######################################################################################################

25 Faça um teste utilizando curl para ambos os paths e salve em /tmp/host.txt Utilize o seguinte curl como exemplo utilizando header host:
curl --header "Host: meuingres.ckackad.com"

curl --header "Host: meuingress.ckackad.com" 10.107.102.181
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>