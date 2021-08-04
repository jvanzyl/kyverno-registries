#!/usr/bin/env bash

rm -f z*

kyverno apply registry-policies.yaml -r test-pod-with-quay-io.yaml -s @=quay-io -o z-quay-io.yaml
kyverno apply registry-policies.yaml -r test-pod-with-gcr-io.yaml -s @=grc-io -o z-grc-io.yaml
kyverno apply registry-policies.yaml -r test-pod-with-ghcr-io.yaml -s @=ghrc-io -o z-ghrc-io.yaml
kyverno apply registry-policies.yaml -r test-pod-with-docker-io.yaml -s @=docker-io -o z-docker-io.yaml
kyverno apply registry-policies.yaml -r test-pod-with-docker.yaml -s @=docker -o z-docker.yaml
kyverno apply registry-policies.yaml -r test-pod-with-docker-library.yaml -s @=docker-library -o z-docker-library.yaml
kyverno apply registry-policies.yaml -r test-pod-with-docker-library-no-tag.yaml -s @=docker-library-no-tag -o z-docker-library-no-tag.yaml
