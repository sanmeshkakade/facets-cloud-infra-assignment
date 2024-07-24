# Facets Cloud Infra Assignment

## Prerequisites and Assumptions

- The choice of operating system was ubuntu.
- Dependencies such as docker, helm, kubectl, minikube and terraform are preinstalled.

## Commands executed

- Start minikube

```bash
minikube start - driver=docker
```

- Create required namespaces and create deployments and services for blue app and green app

```bash
kubectl create -f ./namespace.yaml
kubectl create -f ./blue-app.yaml
kubectl create -f ./green-app.yaml
```

- Install nginx ingress controller using helm

```bash
helm install nginx-ingress oci://ghcr.io/nginxinc/charts/nginx-ingress --version 1.3.1
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
