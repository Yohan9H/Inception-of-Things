#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "[k42s] firewall disabled"
sudo ufw disable || echo "UFW not installed, skipping"

echo "[k42s] install packages"
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y net-tools curl

echo "[k42s] k3s installation on node"
curl -sfL https://get.k3s.io | K3S_URL="https://$MASTERNODE_IP:6443" K3S_TOKEN="12345" sh -s - --node-ip=$WORKERNODE_IP --flannel-iface=eth1