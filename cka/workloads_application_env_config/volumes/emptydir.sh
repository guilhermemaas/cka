#É um ponto de montagem efêmero.
#Em memória, vai durar até o pod morrer, e pode ser dividodo com outros com
#containers no mesmo pod.

#Force recreate:
kubectl replace -f emptydir-pod.yml --force --grace-period 0