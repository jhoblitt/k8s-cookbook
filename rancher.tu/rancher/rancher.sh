#!/bin/bash

set -ex

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update

kubectl create namespace cattle-system

helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.tu.lsst.org \
  --set ingress.tls.source=letsEncrypt \
  --set letsEncrypt.email=hreinking@lsst.org \
  --version v2.3.5 \
  --set replicas=1

kubectl -n cattle-system rollout status deploy/rancher
