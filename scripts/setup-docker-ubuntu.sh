#!/bin/bash

set -euo pipefail

# install docker
sudo apt-get remove -y docker docker-engine docker.io containerd runc 
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo systemctl enable docker && sudo systemctl start docker
sudo systemctl enable containerd && sudo systemctl start containerd

sudo usermod -aG docker vagrant
sudo apt-mark hold docker-ce docker-ce-cli containerd.io

# cgoup
sudo mkdir -p /etc/docker
cat <<'EOF' | sudo tee -a /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

# Restart Docker
sudo systemctl daemon-reload
sudo systemctl restart docker
