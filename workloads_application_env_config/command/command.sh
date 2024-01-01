#Uma maneira de sobescrever o entrypoint original da imagem
                    #Docker          | Kubernets:
                    #Entrypoint     |  command
#Argumentos         Cmd            |   args

#Uso:
command ["/bin/sh"]
args: ["-c", "while true; do echo hello; sleep 10; done"]

kubectl run command --image=nginx --command --dry-run=client -o yaml -- /bin/sh -c env

#Install ps: apt update && apt g2t6bhrv 5u procps -y