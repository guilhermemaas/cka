#Objeto de API do Kubernetes que vai gerenciar acesso externos de dentro do cluster
#Baseado em HTTP, vai fornecer um balanceador de carga
#Podemos oferecer um certificado https em cima dele
#Ele pode ofercer um vhost baseado em nome?

#Em resumo vai export rotas http/https, e export serviços através dele.

"Desenho"
                                                |---------> POD
Cliente --HTTP---> Ingress - Rotas -------> Service
                                                |---------> POD

#Não vem instalado por padrão
#Temos que instalar.

#Nginx Ingress Controller:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/baremetal/deploy.yaml

kubectl describe deploy ingress-nginx-controller -n ingress-nginx

#Ingress Class
--ingress-class=nginx

#2 princpais tipos de Rules:
- Baseado em host
- Baseado em Paths

#pathType: Exact:
rules:
- http:
    paths:
    - path: /foo/var/xpto/
    pathType: Exact

#Obs.: TEM que ter inclusve a / final

#pathType: Prefix:
rules:
- http:
    paths:
    - path: /foo
    pathType: Prefix


#Lab ingress1.yaml
kubectl run foo-nginx --image nginx --port 80
kubectl expose pod foo-nginx --port 80 --target-port 80

curl 10.109.210.177
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>

kubectl get svc -n ingress-nginx
NAME                                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.111.93.44     <none>        80:30105/TCP,443:31480/TCP   29m
ingress-nginx-controller-admission   ClusterIP   10.100.233.134   <none>        443/TCP                      29m

#acessar o ingress
curl http://192.168.1.106:30105/foo
http://192.168.1.106:30105 -> Sem rota, apenas porta do ingress, bate no nginx do ingress
http://192.168.1.106:30105/foo -> Bate no nginx do container dentro do pod

#Pra direcionar pra raíz precisa configurar um rewrite

ingress1.yaml

#Agora sim, acessando o ingress:
http://192.168.1.106:30105/foo
foi pra index do nginx default


###
#Lab 2
kubectl run bar-httpd --image httpd --port 80
kubectl expose pod bar-httpd --port 80 --target-port 80

###
#Lab 3
#Default backend
kubectl run default-backend --image nginx --port 80
kubectl expose pod default-backend --port 80 --target-port 80

http://foo.xpto.xyz:30105/
http://bar.xpto.xyz:30105/

###
#Criar um ingress pelo kubectl
kubectl create ingress ingress3 --class nginx --rule=/foo=foo-nginx:80 --dry-run=client -o yaml
