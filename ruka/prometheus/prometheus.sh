#!/bin/bash

set -ex

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install \
  kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --create-namespace --namespace prometheus \
  --version v44.2.1 \
  --atomic \
  --values - <<EOF
prometheus:
  prometheusSpec:
    remoteWrite:
      - url: https://mimir.o11y.dev.lsst.org/api/v1/push
EOF
