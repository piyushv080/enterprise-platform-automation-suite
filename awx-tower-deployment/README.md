# AWX Deployment on Rancher K3s (Without Docker Licensing)

## Overview
This guide explains how to deploy AWX Tower on a K3s Kubernetes cluster using the AWX Operator,
and build custom Ansible Execution Environments without Docker licensing issues.

## Prerequisites
- CentOS 8 or similar Linux OS
- curl, kubectl, ansible-builder, docker installed
- GitLab or other container registry access

## Step 1: Install K3s
curl -sfL https://get.k3s.io | sudo bash -
sudo su -
kubectl get nodes
kubectl version --short

## Step 2: Deploy AWX Operator
kubectl apply -f https://raw.githubusercontent.com/ansible/awx-operator/0.13.0/deploy/awx-operator.yaml
kubectl get pods -A
kubectl logs -f awx-operator-

## Step 3: Create AWX Instance
Create awx.yaml:

apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx3
spec:
  service_type: nodeport
  ingress_type: none
  hostname: awx3.testingenv.home

Apply it:
kubectl apply -f awx.yaml
kubectl logs -f awx-operator-

## Step 4: Get AWX Admin Password
kubectl get secret awx3-admin-password -o jsonpath="{.data.password}" | base64 --decode

## Step 5: Build Execution Environment
Create execution-environment.yml:

version: 1
dependencies:
  galaxy: requirements.yml
  python: requirements.txt

additional_build_steps:
  prepend: |
    RUN pip3 install --upgrade pip setuptools
  append:
    - RUN ls -la /etc

requirements.txt:
junos-eznc
jsnapy
jxmlease

requirements.yml:
collections:
  - juniper.device

Build and push:
ansible-builder build --tag registry.gitlab.com/<username>/ansible-ee-junos
docker push registry.gitlab.com/<username>/ansible-ee-junos

## Step 6: Verify Services
kubectl get svc
kubectl get secrets

## References
- https://blog.kurokobo.com/archives/category/it/ansible
- https://www.server-world.info/en/note?os=CentOS_Stream_9&p=ansible&f=9
