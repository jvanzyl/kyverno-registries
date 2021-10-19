#!/usr/bin/env bats

function executePolicy() {
  registry=${1}
  expectedResult=${2}
  kyverno apply registry-policies.yaml \
    -r test-pod-with-${registry}.yaml \
    -s @=${registry} | grep "${expectedResult}"
}

@test "Kyverno registry policy for quay.io" {
  executePolicy "quay-io" "harbor.myco.com/quay.io/jetstack/cert-manager:v1.4.1"
  [ $? -eq 0 ]
}

@test "Kyverno registry policy for gcr.io" {
  executePolicy "gcr-io" "harbor.myco.com/gcr.io/heptio-images/eventrouter:v0.3"
  [ $? -eq 0 ]
}

@test "Kyverno registry policy for ghcr.io" {
  executePolicy "ghcr-io" "harbor.myco.com/ghcr.io/heptio-images/eventrouter:v0.3"
  [ $? -eq 0 ]
}

@test "Kyverno registry policy for docker.io" {
  executePolicy "docker-io" "harbor.myco.com/docker.io/velero/velero:v1.6.2"
  [ $? -eq 0 ]
}

@test "Kyverno registry policy for docker" {
  executePolicy "docker" "harbor.myco.com/docker.io/velero/velero:v1.6.2"
  [ $? -eq 0 ]
}

@test "Kyverno registry policy for docker library" {
  executePolicy "docker-library" "harbor.myco.com/docker.io/nginx:latest"
  [ $? -eq 0 ]
}

@test "Kyverno registry policy for docker library without tag" {
  executePolicy "docker-library-no-tag" "harbor.myco.com/docker.io/nginx"
  [ $? -eq 0 ]
}

@test "Kyverno registry policy for pod with multiple containers" {
  executePolicy "multiple-containers" "harbor.myco.com/ghcr.io/heptio-images/eventrouter:v0.3"
  [ $? -eq 0 ]
  executePolicy "multiple-containers" "harbor.myco.com/quay.io/jetstack/cert-manager:v1.4.1"
  [ $? -eq 0 ]
}
