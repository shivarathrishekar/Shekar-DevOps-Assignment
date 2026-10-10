#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="demo"
NAMESPACE="demo"
RELEASE="demo"
IMAGE="demo-app:1.0.0"

command -v kind >/dev/null || { echo "kind is required"; exit 1; }
command -v kubectl >/dev/null || { echo "kubectl is required"; exit 1; }
command -v helm >/dev/null || { echo "helm is required"; exit 1; }
command -v docker >/dev/null || { echo "docker is required"; exit 1; }

if ! kind get clusters | grep -qx "$CLUSTER_NAME"; then
  kind create cluster --name "$CLUSTER_NAME" --wait 60s
fi

kubectl cluster-info --context "kind-$CLUSTER_NAME"

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx 2>/dev/null || true
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.ingressClassResource.name=nginx \
  --wait --timeout 5m

docker build -t "$IMAGE" ./service
kind load docker-image "$IMAGE" --name "$CLUSTER_NAME"

kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install "$RELEASE" ./chart \
  --namespace "$NAMESPACE" \
  --set image.repository=demo-app \
  --set image.tag=1.0.0 \
  --wait --timeout 5m

echo "Deployment complete. Check with: kubectl get pods -n $NAMESPACE"
