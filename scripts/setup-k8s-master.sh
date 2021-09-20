#!/bin/bash

set -euo pipefail

IPADDR=$(ip a show enp0s8 | grep inet | grep -v inet6 | awk '{print $2}' | cut -f1 -d/)

sudo kubeadm init \
  --control-plane-endpoint="${IPADDR}:6443" \
  --apiserver-advertise-address="${IPADDR}" \
  --kubernetes-version="v1.22.0" \
  --pod-network-cidr="192.168.0.0/16" \
  --upload-certs

mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config

mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config

echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc

curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz
sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
rm cilium-linux-amd64.tar.gz

cilium install

cat <<EOF | tee -a /share/join-worker.sh
#!/bin/bash
sudo $(kubeadm token create --print-join-command)
EOF
chmod +x /share/join-worker.sh 
