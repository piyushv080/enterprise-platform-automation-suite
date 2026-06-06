# AWX Deployment on Rancher K3s (Without Docker Licensing)

## 1. Update Your System
sudo apt update
sudo apt upgrade -y

## 2. Install k3s
curl -sfL https://get.k3s.io | sh -

## 3. Give Non-root User Access to K3s Config
sudo chown $USER:$USER /etc/rancher/k3s/k3s.yaml
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

## 4. Verify Kubernetes Cluster
kubectl version
kubectl get nodes
kubectl get pods -A

## 5. Install Kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo mv kustomize /usr/local/bin

## 6. Create Kustomization Directory
mkdir awx-deploy && cd awx-deploy

## 7. Create kustomization.yaml
nano kustomization.yaml

## 8. Apply Kustomize Configuration
kubectl apply -k .

## 9. Verify Operator is Running
kubectl get pods -n awx

## 10. Create AWX Instance
nano awx-demo.yaml

## 11. Add Instance to Kustomization
nano kustomization.yaml

## 12. Reapply Kustomize Configuration
kubectl apply -k .

## 13. Check POD Status
kubectl get pods -n awx

## 14. View Logs
kubectl logs -f deployment/awx-operator-controller-manager -c awx-manager -n awx

## 15. Retrieve Admin Password
kubectl get secret awx-demo-admin-password -n awx -o jsonpath="{.data.password}" | base64 --decode ; echo

## 16. Access the AWX Dashboard
http://<your-server-ip>:32000
Username: admin
Password: (from previous step)

## References
- https://blog.kurokobo.com/archives/category/it/ansible
- https://www.server-world.info/en/note?os=CentOS_Stream_9&p=ansible&f=9
