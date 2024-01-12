#Recurso personalizado que extende a api do Kubernetes
#Um recurso é uma api do Kubernetes
#Vai armazenar uma coleção de objetos da api do kubernetes para um determinado tipo
#Por exemplo Pod, vai ter todos os recursos pra manter e criar pods.
#Custom Resource Definition

#Custom Controllers
#Custom Resource Definitions

#Operators

#Buscar crds:
kubectl get crd

alunos.linuxtips.io
alunos=resource
linuxtips.io=group

#crd.yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: alunos.linuxtips.io
spec:
  group: linuxtips.io
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              nomeAluno:
                type: string
              curso:
                type: string
              nota:
                type: integer
  scope: Namespaced
  names:
    plural: alunos
    singular: aluno
    kind: Alunos
    shortNames:
    - al  

#aluno.yaml
apiVersion: linuxtips.io/v1
kind: Alunos
metadata:
  name: earlyaccess
spec:
  nomeAluno: "Guilherme Augusto Maas"
  curso: "CKA-CKAD-CKS"
  nota: 10

kubectl get al
kubectl get alunos
kubectl get aluno

kubectl describe al earlyaccess
Name:         earlyaccess
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  linuxtips.io/v1
Kind:         Alunos
Metadata:
  Creation Timestamp:  2024-01-10T14:54:58Z
  Generation:          1
  Resource Version:    152756
  UID:                 94e37328-2006-4147-b05d-46d09f76254b
Spec:
  Curso:       CKA-CKAD-CKS
  Nome Aluno:  Guilherme Augusto Maas
  Nota:        10
Events:        <none>

