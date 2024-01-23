#!/usr/bin/env bash

NAMESPACE="opensearch"
VERSION="2.4.0"

set -ex

helm repo add opensearch-operator https://opensearch-project.github.io/opensearch-k8s-operator
helm repo update

helm upgrade --install opensearch-operator opensearch-operator/opensearch-operator \
     --create-namespace --namespace "${NAMESPACE=}" \
     --atomic --timeout 15m0s \
     --version "${VERSION=}"

kubectl --namespace "${NAMESPACE=}" apply -f ./ayekan-cluster.yaml
