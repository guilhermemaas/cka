#Executa uma vez, executa o que precisa e morre (deletado).
#Cron job executa os jobs.

#Lab1 (job.yaml)
#Fazer um job que usa a imagem do ubuntu e roda um echo.
kubectl get job
NAME      COMPLETIONS   DURATION   AGE
meu-job   1/1           10s        4m11s

kubectl get pods
NAME            READY   STATUS              RESTARTS   AGE
meu-job-ngr7n   0/1     Completed           0          4m46s

#Ver o que rodou
kubectl logs meu-job-ngr7n

#Opções mais importantes:
spec:
  backoffLimit: 1 #Quantidade de vezes que vai tentar executar se der erro.
  completions: 5 #Quantidade de vezes que o job vai rodar
  parallelism: 2 #Quantidade de pods que vão ser executados ao mesmo tempo para concluir o job.
  activeDeadlineSec: 1 #Quantidade máxima de segundos pra esse job executar.

#Criar job manualmente
kubectl create job meu-job --image=ubuntu --dry-run=client -o yaml > job2.yaml