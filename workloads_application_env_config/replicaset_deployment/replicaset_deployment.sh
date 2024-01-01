#Gerar yaml do replicaset
kubectl get rs -o yaml meu-rs

#Criar um deployment manualmente
kubectl create deployment nginx --image nginx -o yaml --dry-run=client > rs2.yaml

#REPLICASET
#Replicas
#  Selectors
#    #Template

#DEPLOYMENT
#Versionador de replicaset
#Rollback, consultar status

#Escalar e desescalar pods alterando o deployment:
kubectl scale deploy --replicas 5 primeiro-deploy 

#ROLLOUT:


kubectl rollout history deploy primeiro-deploy
#xamples:
  # Rollback to the previous deployment
  kubectl rollout undo deployment/abc

  # Check the rollout status of a daemonset
  kubectl rollout status daemonset/foo

  # Restart a deployment
  kubectl rollout restart deployment/abc

  # Restart deployments with the app=nginx label
  kubectl rollout restart deployment --selector=app=nginx

#Available Commands:
#  history       View rollout history
#  pause         Mark the provided resource as paused
#  restart       Restart a resource
#  resume        Resume a paused resource
#  status        Show the status of the rollout
#  undo          Undo a previous rollout

kubectl get pod primeiro-deploy-7b76b569cd-5ddzc -o yaml | grep image

#Salvar revisão no apply
kubectl apply -f xptop.yaml --record=true

#Rollback pra uma revision anterior:
kubectl rollout undo --to-revision 3 deploy primeiro-deploy

#Pausar um deployment
kubectl rollout pause deploy primeiro-deploy

#Resume em um deployment:
kubectl rollout resume deploy primeiro-deploy

#####
#Estratégias de deploy:
####
kubectl explain deployment.spec.strategy

 #10   template:
 #11     metadata:
 #12       labels:
 #13         app: nginx
 #14     spec:
 #15       strategy:
 #16         type: Recreate
 #Por default é RollingUpdate
 #Ter 10 réplicas, e quiser que altere 1 pod por vez, gradualmente

 #Se eu quiser fazer rolling update, atualizando 1 por vez, mas com 0% de indisponibilidade
 #/performance:
 spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 10%
      maxUnavailable: 0
#Dessa maneira ele vai adicionar 1 pod a mais (11), se o meu número de réplicas é 10

#!!!! Pode ser ou em quantidade, ou em % (Porcentagem)

#Criar primeiro o total de pods e então matar todos:
 spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 100%
      maxUnavailable: 0

#
kubectl create deploy nginx3 --image nginx --port 80 -o yaml --dry-run