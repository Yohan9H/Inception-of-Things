#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "[k42s] firewall disabled"
sudo ufw disable || echo "UFW not installed, skipping"

echo "[k42s] install packages"
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y net-tools curl

echo "[k42s] k3s installation on node"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip=$MASTERNODE_IP --flannel-iface=eth1" K3S_KUBECONFIG_MODE="644" sh -s - --token 12345

echo "[k42s] server token are shared via synced_folder technique"
sudo cp /var/lib/rancher/k3s/server/token /home/vagrant/shared/

echo "[k42s] install kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "[k42s] waiting for k3s to generate config file..."
sleep 15

mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config
echo 'alias k="kubectl"' >> /home/vagrant/.bashrc