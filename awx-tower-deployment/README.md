# AWX Tower Deployment on Rancher K3s
> Deploy AWX Tower on K3s Kubernetes using AWX Operator
> without Docker licensing issues.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Step 1 - Install K3s](#step-1---install-k3s)
- [Step 2 - Deploy AWX Operator](#step-2---deploy-awx-operator)
- [Step 3 - Create AWX Instance](#step-3---create-awx-instance)
- [Step 4 - Get Admin Password](#step-4---get-admin-password)
- [Step 5 - Build Execution Environment](#step-5---build-execution-environment)
- [Step 6 - Verify Services](#step-6---verify-services)
- [References](#references)

---

## Overview
This guide deploys AWX Tower on a K3s Kubernetes cluster using the
AWX Operator and builds custom Ansible Execution Environments
without Docker licensing restrictions.

---

## Prerequisites

| Requirement       | Version / Notes                        |
|-------------------|----------------------------------------|
| OS                | CentOS 8 / CentOS Stream 9             |
| curl              | Latest                                 |
| kubectl           | Matching K3s version                   |
| ansible-builder   | Latest                                 |
| Container Registry| GitLab Registry or any private registry|

---

## Step 1 - Install K3s

```bash
# Install K3s
curl -sfL https://get.k3s.io | sudo bash -

# Switch to root
sudo su -

# Verify node is ready
kubectl get nodes

# Verify kubectl version
kubectl version --short
