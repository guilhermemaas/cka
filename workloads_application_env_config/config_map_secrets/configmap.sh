kubectl replace -f nginx-cm-one-parameter.yml --force --grace-period 0
kubectl run nginx --image nginx --dry-run=client -o yaml >> nginx-cm.yml
kubectl get cm
kubectl exec -it nginx -- env

#Configmap fromEnv > Pegar todos as chaves do configMap.
#valeuFrom: configMapKeyRef > exportar como env o valor de uma chave do configMap.

#Criar configmap na mão:
kubectl create configmap segundo-cm --from-literal=ip=10.0.0.2 --from-literal=server="web" --dry-run=client -o yaml

#Criar com base em um arquivo:
kubectl create configmap terceiro-cm --from-file config.txt --dry-run=client -o yaml

####Pra valer alteração de configmap (kubectl edit cm terceiro-cm, por exemplo), tem que reiniciar os pods (deletar e recriar).

#Configmap imutável (Não se pode alterar)
#  1 apiVersion: v1 
#  2 kind: ConfigMap
#  3 metadata:      
#  4   name: primeiro-cm
#  5 data:          
#  6   ip: "10.0.0.1"
#  7   server: "web"
#  8 imutable: true 