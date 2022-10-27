#!/bin/bash

set -ex

VERSION='2.6.1'

print_error() {
  >&2 echo -e "$@"
}

fail() {
  local code=${2:-1}
  [[ -n $1 ]] && print_error "$1"
  # shellcheck disable=SC2086
  exit $code
}

has_cmd() {
  local command=${1?command is required}
  command -v "$command" > /dev/null 2>&1
}

require_cmds() {
  local cmds=("${@?at least one command is required}")
  local errors=()

  # accumulate a list of all missing commands before failing to reduce end-user
  # install/retry cycles
  for c in "${cmds[@]}"; do
    if ! has_cmd "$c"; then
      errors+=("prog: ${c} is required")
    fi
  done

  if [[ ${#errors[@]} -ne 0 ]]; then
    for e in "${errors[@]}"; do
      print_error "$e"
    done

    fail 'failed because of missing commands'
  fi
}

require_cmds helm kubectl


helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update

helm upgrade --install \
  --atomic \
  kyverno kyverno/kyverno \
  --create-namespace --namespace kyverno \
  --version "v${VERSION}" \
  --set image.tag='v1.8.1' \
  --set replicaCount=3

kubectl apply -f policies
