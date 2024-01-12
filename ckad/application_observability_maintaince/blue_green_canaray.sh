###############
###Blue Green
###############

#Com deployment a gente tem as regras de: 
- RollingUpdate
- Recreate
#RollingUpdate é o padrão.

Blue -> Green
#Exemplo, troca bruda da versão 1 pra 2, e é isso.

kubectl expose deploy green --name svc-frontend --port 80 --target-port 80 --dry-run=client -o yaml >> bluegreen-svc.yaml

kubectl exec -it green-bf74cc585-pnkmr -- bash
echo "Green" >> /usr/share/nginx/html/index.html

#Curl no service
curl 10.104.61.72
<p><em>Thank you for using nginx.</em></p>
</body>
</html>
Green
Green

for x in {1..100}; do curl 10.104.61.72 && sleep 1; done

#Lab do bluee green:
- Fazer um deployment v1 que vai ser o green.
- Fazer um deployment v2 que vai ser o blue.
- Expor um service com match label apontando pro green.
- tmux >  for x in {1..100}; do curl 10.104.61.72 && sleep 1; done
- Alterar o matchlabel do svc pra versão do blue
- Alterar o matchlabel do svc pra versão do green pra simular um rollback.

###############
###Canary:
###############
#Direcionar % de tráfego pra uma nova versão.
#É meio primitivo, por que controla pela quantidade de pods. Xisde

Pode usar o cenário acima, só que:
- Remover a label do seletor version=v1, assim vai mandar tráfego pros 2 (blue/green)

# E pra controlar o % de tráfego, é com base na quantidade, pensando que queremos 90% pro green. Então deixamos o blue com 10% (1 Pod) e o Green com 90% (9 Pod)
kubectl scale deployment green --replicas 9                  

#agora que 100% do tráfego pra blue:
kubectl scale deployment green --replicas 0