#Como vamos saber quando a aplicação está saudável para
#receber tráfego

- Lifecycle de um pod no Kubernetes:
    - Pending: Foi aceito, mas não tá pronto pra rodar. Não ter recurso pra rodar, faz ficar aqui.
    - Running: Comando do container executou e está rodando com sucesso.
    - Succeeded: Todos os contêineres foram executados com sucesso, e não serão reiniciados. Para jobs?
    - Failed: Quando o comando do entrypoint está falhando, qualquer comando que não tem uma saída 0.
    - Unknown: Por algum motivo, não foi possível obter o estado do pod.


4 Tipos de verificação para cada probe:
 - Command -> Sempre espera uma saída de comando 0 (Sucesso)
 - HTTP Request
 - Conexão TCP
 - Conexão gRPC

#Como eu verifico o exitcode do meu comando?
echo $?


Probes types:
- LivenessProbe -> Verifica se o container tá vivo, o comando do entrypoint foi executado com sucesso.
#Mas não indica que a aplicação esteja rodando sem falhas de fato.
# Ver de tempos em tempos se o container tá vivo.

- ReadinessProbe -> Verifica se o container já está pronto, saudável e pronto para receber tráfego.
#Digamos que o container demora 20 seg pra subir, vai garantir que o pod só seja acessível
#quando a aplicação estiver up e operante.

- Startup Probes: O Kubernetes ignora o Liveness e Readiness até concluir o startup.

#Lab1
#pod_probehttp1.yaml
#Instalar um pod com nginx, com livenessProbe http na porta 80
#Depois entrar no container, e alterar a porta pra 8080

vim /etc/nginx/conf.d/default.conf
nginx -s reload

Events:
  Type     Reason     Age                  From               Message
  ----     ------     ----                 ----               -------
  Normal   Scheduled  4m43s                default-scheduler  Successfully assigned default/nginx-probe to cka-control-plane
  Normal   Pulled     4m41s                kubelet            Successfully pulled image "nginx" in 1.151993676s (1.152030446s including waiting)
  Warning  Unhealthy  23s (x5 over 43s)    kubelet            Liveness probe failed: Get "http://10.244.0.247:80/": dial tcp 10.244.0.247:80: connect: connection refused
  Normal   Killing    23s                  kubelet            Container nginx failed liveness probe, will be restarted
  Normal   Pulling    22s (x2 over 4m43s)  kubelet            Pulling image "nginx"
  Normal   Created    21s (x2 over 4m41s)  kubelet            Created container nginx
  Normal   Started    21s (x2 over 4m41s)  kubelet            Started container nginx
  Normal   Pulled     21s                  kubelet            Successfully pulled image "nginx" in 1.332697644s (1.332721874s including waiting)
 
#Lab2
#pod_probecommand1.yaml
mover o default.conf
kubectl exec -it nginx-probe -- bash
cd /etc/nginx/conf.d
mv default.conf default.conf.old


#Ordem de execução:
    1 - startupProbe: Os demais só vão executar se esse aqui der certo... Serve pra aplicação pesada, que demora pra subir.
    2 - readinessProbe
    3 - livenessProbe, pra seguir verificando se tá vivo (vai executar mesmo se o Readiness não estiver concluído)

    readinessProbe:
      initialDelaySeconds: 5
      periodSeconds: 5
      successThreshold: 10
      tcpSocket:
        port: 80
    livenessProbe:
      initialDelaySeconds: 10  #Quantos segundos após o start do container vai fazer a checkagem, padrão 0 seg
      periodSeconds: 5 #De quanto em quanto segundos vai executar o probe
      successThreshold: 1 #Número de checagens para entender que está healthy. Só no Readiness que pode ser maior que 1
      failureThreshold: 5 #Quantas vezes pra falhar, pra reiniciar o container. vezes seguidas?
      timeoutSeconds: 2 #Timeout pra execução da checagem
      httpGet:
        path: /
        port: 80


➜  probes git:(main) ✗ kubectl get po
NAME                        READY   STATUS    RESTARTS   AGE
deploy-1-78675855b7-5rsth   1/1     Running   0          4d21h
deploy-1-78675855b7-5vckd   1/1     Running   0          4d21h
deploy-1-78675855b7-fpqjl   1/1     Running   0          4d21h
deploy-1-78675855b7-gzgsp   1/1     Running   0          4d21h
deploy-1-78675855b7-hqcs7   1/1     Running   0          4d21h
deploy-1-78675855b7-v56f7   1/1     Running   0          4d21h
nginx-probe                 0/1     Running   0          51s
➜  probes git:(main) ✗ kubectl get po
NAME                        READY   STATUS    RESTARTS   AGE
deploy-1-78675855b7-5rsth   1/1     Running   0          4d21h
deploy-1-78675855b7-5vckd   1/1     Running   0          4d21h
deploy-1-78675855b7-fpqjl   1/1     Running   0          4d21h
deploy-1-78675855b7-gzgsp   1/1     Running   0          4d21h
deploy-1-78675855b7-hqcs7   1/1     Running   0          4d21h
deploy-1-78675855b7-v56f7   1/1     Running   0          4d21h
nginx-probe                 1/1     Running   0          57s

#Observar as opções com kubectl explain
kubectl explain pod.spec.containers.livenessProbe --recursive
KIND:     Pod
VERSION:  v1

RESOURCE: livenessProbe <Object>

DESCRIPTION:
     Periodic probe of container liveness. Container will be restarted if the
     probe fails. Cannot be updated. More info:
     https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes

     Probe describes a health check to be performed against a container to
     determine whether it is alive or ready to receive traffic.

FIELDS:
   exec <Object>
      command   <[]string>
   failureThreshold     <integer>
   grpc <Object>
      port      <integer>
      service   <string>
   httpGet      <Object>
      host      <string>
      httpHeaders       <[]Object>
         name   <string>
         value  <string>
      path      <string>
      port      <string>
      scheme    <string>
   initialDelaySeconds  <integer>
   periodSeconds        <integer>
   successThreshold     <integer>
   tcpSocket    <Object>
      host      <string>
      port      <string>
   terminationGracePeriodSeconds        <integer>
   timeoutSeconds       <integer>