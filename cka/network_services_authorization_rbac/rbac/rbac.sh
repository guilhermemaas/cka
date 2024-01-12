#role based access control
#Todas as permissões para a api do k8s
#Autorização global do nosso cluster

Access
Authentication
Autorization -> RBAC

cat /etc/kubernetes/manifests/kube-apiserver.yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 192.168.1.106:6443
  creationTimestamp: null
  labels:
    component: kube-apiserver
    tier: control-plane
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-apiserver
    - --advertise-address=192.168.1.106
    - --allow-privileged=true
    - --authorization-mode=Node,RBAC

#A autorização se dá por meio de:
Rules: Por namespace (é instanciada por namespace)
ClusterRules: Global, podeserá ser usada em todo o cluster 

#Não é possível negar acesso a recursos.
#A permissão é sempre "permitindo" acesso a um recurso.

O que é liberado:
- Objeto
- Verbo: Get, delete, list, create, watch, etc
#é a ação que u osuário vai poder tomar

#Para saber qual o api group:
kubectl api-resources

#listar roles de todo o cluster:
kubectl get clusterRole

#Criar pelo kubectl
kubectl create role leitor2 --verb get,watch,list --resource secrets --dry-run=client -o yaml

#Quando cria uma role com objetos de grupos de api diferentes, ele já organiza corretamente:
kubectl create role leitor2 --verb get,watch,list,jobs --resource secrets,pods,jobs --dry-run=client -o yaml
Warning: 'jobs' is not a standard resource verb
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  creationTimestamp: null
  name: leitor2
rules:
- apiGroups:
  - ""
  resources:
  - secrets
  - pods
  verbs:
  - get
  - watch
  - list
  - jobs
- apiGroups:
  - batch
  resources:
  - jobs
  verbs:
  - get
  - watch
  - list
  - jobs


#RoleBinding: Casar/vincular a role com um usuário
RoleBinding: Estou dizendo que o usuário vai ter a permissão dentro de um namspace.
ClusterRoleBinding: Estou dizendo que o usuário vai ter essa permissão a nível global.

#O bind pode ser por:
- Group
- ServiceAccount
- User

#Criar um usuário/ServiceAccount
kubectl create serviceaccount leitor
kubeclt create sa leitor

#RoleBinding:
rolebinding1.yaml

#Checar o que o meu serviceAccount/User consegue fazer no cluster:
kubectl auth can-i get secrets --as system:serviceaccount:default:leitor
yes

kubectl auth can-i get secrets --as system:serviceaccount:default:leitor
yes

kubectl auth can-i get deploy --as system:serviceaccount:default:leitor
no

#Criar Rolebinding via kubectl
kubectl create rolebinding rolebinding2 --role=leitor-secrets --serviceaccount=default:leitor  --dry-run=client -o yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  creationTimestamp: null
  name: rolebinding2
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: leitor-secrets
subjects:
- kind: ServiceAccount
  name: leitor
  namespace: default

#ClusterRolebinding via kubectl
kubectl create rolebinding 

#um teste com ClusterRoleBinding:
#clusterrolebingin1.yaml
kubectl describe clusterrolebinding leitor-cluster-binding
kubectl apply -f clusterrolebinding1.yaml
kubectl auth can-i list secrets -n kube-system --as system:serviceaccount:default:leitor-global
yes

#Criar um clusterrolebingin via kubectl:
kubectl create clusterrolebinding binding --clusterrole leitor-cluster --serviceaccount=default:leitor-global --dry-run=client -o yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  creationTimestamp: null
  name: binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: leitor-cluster
subjects:
- kind: ServiceAccount
  name: leitor-global
  namespace: default