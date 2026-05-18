#!/bin/bash
echo "🛠️ Installation des prérequis (Docker, Kubectl, K3d)..."

sudo apt-get update
sudo apt-get install -y docker.io curl

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "Outils installés avec succès !"