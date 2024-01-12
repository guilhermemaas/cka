#Cria o agendameto do job. Simples
#O mesmo padrão do cron do Linux
#Se quiser se basear:
cat /etc/crontab

#Ver os campos padrão do cronjob:
kubectl explain cronjob.spec.jobTemplate.spec

#Criar um cronjob manualmente
kubectl create cronjob meucronjob2 --image ubuntu --schedule="* * * * *" --dry-run=client -o yaml >> cronjob.yaml