# Facets Cloud Infra Assignment

## Part-I Kubernetes Manifests  

### Prerequisites and Assumptions

- The choice of operating system was ubuntu.
- Dependencies such as docker, helm, kubectl, minikube and terraform are pre-installed.

### Commands executed

- Start minikube

```bash
minikube start - driver=docker
```

- Install nginx ingress controller using helm

```bash
kubectl create -f ./namespace.yaml
helm install nginx-ingress oci://ghcr.io/nginxinc/charts/nginx-ingress --version 1.3.1
```

- Assign the external ips to the nginx-ingress-controller load balancer service as it won't be assigned in minikube

- - Copy the IP echoed by below command

```bash
 echo "$(minikube ip)" 
```

- - Edit the service

```bash
kubectl edit svc nginx-ingress-controller -n nginx-ingress
```

- - Add the below mentioned block under spec with proper indentation and save it

```text
externalIPs:
- COPIED_IP_OF_MINIKUBE
```

- Create required namespaces and create deployments and services for blue app and green app

```bash
kubectl create -f ./blue-app.yaml
kubectl create -f ./green-app.yaml
```

- Create virtual server for exposing blue green apps

```bash
kubectl apply -f virtual-server.yaml
```

- Add domain of app to known hosts to os

```bash
echo "$(minikube ip) app.com" | sudo tee -a  /etc/hosts
```

- To test the traffic distribution

```bash
for i in $(seq 1 20); do curl app.com; done
```

## Part-II Automating using Terraform

### Prerequisites and Assumptions

- The required config to kubernetes cluser is present under `~/.kube/config`

### Commands executed

- Start minikube

```bash
minikube start - driver=docker
```

- I have created two terraform sub dirs, one for installing nginx ingreess controller and other for installing apps. This is done as plan fails if both are created via one plan as kubernetes manifest resource tries to validate if crd is present. This is also a known [issue](https://github.com/hashicorp/terraform-provider-kubernetes/issues/1782).

- Install nginx ingress controller via helm

```bash
cd /terraform/nginx-ingress-controller
terraform init 
terraform plan
terraform apply
```

- Terraform waits for externalIPs to be assigened to load balancer service of nginx, we assign it manually in minikube using the below steps. Once done the apply stage will pass

- - Copy the IP echoed by below command

```bash
 echo "$(minikube ip)" 
```

- - Edit the service

```bash
kubectl edit svc nginx-ingress-controller -n nginx-ingress
```

- - Add the below mentioned block under spec with proper indentation and save it

```text
externalIPs:
- COPIED_IP_OF_MINIKUBE
```

- Create namespace, deployments, services and virtual server for different application

```bash
cd /terraform/apps
terraform init 
terraform plan
terraform apply
```

- Add domain of app to known hosts to os. Not required if done in part I

```bash
echo "$(minikube ip) app.com" | sudo tee -a  /etc/hosts
```

- To test the traffic distribution

```bash
for i in $(seq 1 20); do curl app.com; done
```
