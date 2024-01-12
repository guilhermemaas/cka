#3 Tipos de controle:
- O mínimo e o máximo de recurso que o POD vai poder ter dentro do ns
- Um limite pros storages
- Configuração de default, caso não se configure requests/limits.

#Lab1 ns_limits1.yaml

kubectl describe limitrange limit-ns
Name:       limit-ns
Namespace:  default
Type        Resource  Min   Max   Default Request  Default Limit  Max Limit/Request Ratio
----        --------  ---   ---   ---------------  -------------  -----------------------
Container   cpu       200m  500m  500m             500m           -

kubectl describe ns default
Name:         default
Labels:       kubernetes.io/metadata.name=default
Annotations:  <none>
Status:       Active

No resource quota.

Resource Limits
 Type       Resource  Min   Max   Default Request  Default Limit  Max Limit/Request Ratio
 ----       --------  ---   ---   ---------------  -------------  -----------------------
 Container  cpu       200m  500m  500m             500m           -


 #Tentar subir um pod que não se enquadre:
kubectl apply -f pod_ns_limitsrange1.yaml 

kubectl replace -f pod_ns_limitsrange1.yaml --force --grace-period 0
Error from server (Forbidden): pods "nginx" is forbidden: maximum cpu usage per Container is 500m, but limit is 1000Mi

