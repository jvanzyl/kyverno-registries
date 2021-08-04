# Image Registry Mutations

The use case is to allow an approved set of external registries to be used by our developers, where the image references are rewritten to use an internal Harbor proxy cache we have for the given external registry. For simplicity we create the project in Harbor with a name that matches the registry identifier. For the sake of explanation let's say we want to allow the following external registries:

- gcr.io
- ghcr.io
- quay.io
- docker.io

Additionally for docker.io, we need to deal with the variants where the docker.io registry is implied. So for our list of approved registries above we wish the following transformations to happen:

```
gcr.io/heptio-images/eventrouter:v0.3  -> harbor.myco.com/grc.io/heptio-images/eventrouter:v0.3
ghcr.io/jvanzyl/dimg:1.0.0             -> harbor.myco.com/ghrc.io/jvanzyl/dimg:1.0.0
quay.io/jetstack/cert-manager:v1.4.1   -> harbor.myco.com/quay.io/jetstack/cert-manager:v1.4.1
docker.io/kyverno/kyverno:lastest      -> harbor.myco.com/docker.io/kyverno/kyverno:latest
velero/velero:v1.6.2                   -> harbor.myco.com/docker.io/velero/velero:v1.6.2
nginx:latest                           -> harbor.myco.com/docker.io/nginx:latest
nginx                                  -> harbor.myco.com/docker.io/nginx
```

With these requirements we are using Kyverno to make these changes dynamically as pods are being deployed in our clusters. Please refer to the `registry-policies.yaml` in this directory to see the policies being applied.

Our group is new to Kveryno so our usage of the policies may be sub-optimal. We're happy to improve these policies as we feel they are generally useful for anyone trying to create a hermetic environment for production deployments.

Our issue currently is trying to catch the docker references where the docker.io registry is implied. We have a crude `test.sh` script in the directory which applies the policy file to various pod resources of our different forms above. In our list of transformations we cannot get the last three to work.

NOTE: We are currently building Kyverno from the tip of `main` to get some of the latest fixes being planned for the 1.4.2 release.

[1]: https://goharbor.io/docs/2.3.0/administration/configure-proxy-cache/
