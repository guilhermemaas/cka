#Listar todas as apis:
kubectl api-resources

#Listar todas as versões
kubectl api-versions

#Lab1
#Como habilitar ou desabilitar uma api no kubernetes
#Api Group
#Habilitar o v1alpha1 do rbac

vim /etc/kubernetes/manifests/kube-apiserver.yaml

adicionar no command:
- --runtime-config=rbac.authorization.k8s.io/v1alpha1

#Lab
#Desativar o batch/v1beta1

vim /etc/kubernetes/manifests/kube-apiserver.yaml

adicionar no command:
- --runtime-config=rbac.authorization.k8s.io/v1alpha1,batch/v1beta1=false

kubectl api-versions
admissionregistration.k8s.io/v1
apiextensions.k8s.io/v1
apiregistration.k8s.io/v1
apps/v1
authentication.k8s.io/v1
authorization.k8s.io/v1
autoscaling/v1
autoscaling/v2
batch/v1
certificates.k8s.io/v1
coordination.k8s.io/v1
discovery.k8s.io/v1
events.k8s.io/v1
flowcontrol.apiserver.k8s.io/v1
flowcontrol.apiserver.k8s.io/v1beta3
networking.k8s.io/v1
node.k8s.io/v1
policy/v1
rbac.authorization.k8s.io/v1
scheduling.k8s.io/v1
storage.k8s.io/v1
v1


#Kubectl convert, pra ajudar a migrar um yaml de uma versão antiga pra uma nova
#por exemplo, um ingress antigo pra um novo...

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl-convert"
chmod +x kubectl-convert
mv kubectl-convert /usr/bin/

#Instalar:
install -o root -g root -m 0755 kubectl-convert /usr/local/bin/kubectl-convert #Ou copiar e dar permissão como acima

#pegar a versão de um manifesto
kubectl-convert -f ingress.yaml --output-version networking.k8s.io/v1

