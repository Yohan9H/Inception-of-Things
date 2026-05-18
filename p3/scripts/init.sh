#!/bin/bash

CLUSTER_NAME="iot-cluster"
NAMESPACE="argocd"

echo "Lancement du cluster K3d sur le port 8888..."
k3d cluster create $CLUSTER_NAME --port "8888:8888@loadbalancer"

echo "Creation du namespace ArgoCD..."
kubectl create namespace $NAMESPACE

echo "Installation d'ArgoCD..."
kubectl apply -n $NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Attente du deploiement des pods ArgoCD (Timeout: 600s)..."
kubectl wait --for=condition=ready pod --all --namespace=$NAMESPACE --timeout=600s

if [ $? -eq 0 ]; then
    echo "Connexion d'ArgoCD au depot Git..."
    kubectl apply -f ../confs/application.yml
    echo "ArgoCD est configure et synchronise avec ton GitHub !"

    echo "Ouverture du port pour l'interface web (en arriere-plan)..."
    kubectl port-forward -n $NAMESPACE svc/argocd-server 8080:443 > /tmp/argocd-port-forwarding.log 2>&1 &
    
    echo "Recuperation du mot de passe admin..."
    kubectl -n $NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > /tmp/argo-credentials.txt
    
    echo "TERMINÉ !"
    echo "Connecte-toi sur : https://localhost:8080"
    echo "Utilisateur : admin"
    echo "Mot de passe dispo dans le fichier : /tmp/argo-credentials.txt"
else
    echo "Erreur ! Les pods ArgoCD ne sont pas prets. Verifie ton installation."
fi