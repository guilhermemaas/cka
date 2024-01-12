#CNI - Container Network Interface
#Calico, Weavenet

#Uma faixa de IPs para Pods, uma faixa de IPs para services

#TIPOS:
ClusterIP: IP que o pod ganha e é acessível somente de dentro do cluster.
#Obs.: é o default, se eu não passar um tipo, é esse serviço que é criado.

NodePort: Cria um Cluster IP para ficar acessível internamente, mas também sobe um IP_NODE:PORTA pra esse serviço
ficar acessível.
#Porta alta 30000~30777

LoadBalancer: Expões externamente usando um load balancer de um cloud provider. 
Usa o NodePort + ClusterIP, juntamente de um com um loadbalancer externo que cria as rotas automaticamente.
#Exemplo: EKS + ALB

ExternalName: Cria um DNS/CNAME para um dns externo. Exemplo:
google.com -> buscador.external

#Criar com linha de comando:
kubectl expose pod nginx --name=svc2 --type=ClusterIP --type=NodePort --port=8080 --target-port=80 --dry-run=client -o yaml
#Nesse caso ele vai usar uma porta alta aleatória.

###Testes de conexão:
kubectl exec -it nginx -- curl 10.44.0.3:80