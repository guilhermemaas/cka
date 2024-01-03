#Listar todos os containers:
crictl pods

#Apontar o endpoint pro socket do contianerd:
export CONTAINER_RUNTIME_ENDPOINT=unix:///run/containerd/containerd.sock

#listar pods
crictl pods 

#listar containers
crictl ps

#verificar logs
crictl logs ID