# Using Kyvero and Harbor to safeguard production systems

The use case is to allow an approved set of external registries to be used by our developers, where the image references are rewritten to use an internal Harbor proxy cache we have for the given external registry. For simplicity we create the project in Harbor with a name that matches the registry identifier. For the sake of explanation let's say we want to allow the following external registries:

- `gcr.io`
- `ghcr.io`
- `quay.io`
- `docker.io`

Additionally for `docker.io`, we need to deal with the variants where the docker.io registry is implied. So for our list of approved registries above we wish the following transformations to happen:

```
gcr.io/heptio-images/eventrouter:v0.3  -> harbor.myco.com/gcr.io/heptio-images/eventrouter:v0.3
ghcr.io/jvanzyl/nginx:latest           -> harbor.myco.com/ghcr.io/jvanzyl/nginx:latest
quay.io/jetstack/cert-manager:v1.4.1   -> harbor.myco.com/quay.io/jetstack/cert-manager:v1.4.1
docker.io/nirmata/kyverno:lastest      -> harbor.myco.com/docker.io/nirmata/kyverno:latest
velero/velero:v1.6.2                   -> harbor.myco.com/docker.io/velero/velero:v1.6.2
nginx:latest                           -> harbor.myco.com/docker.io/nginx:latest
nginx                                  -> harbor.myco.com/docker.io/nginx
```

With these requirements we are using Kyverno to make these changes dynamically as pods are being deployed in our clusters. Please refer to the `registry-policies.yaml` in this directory to see the policies being applied.

## Harbor Setup

With Harbor installations this pattern works by setting up each approved external registry as a [registry endpoint][1] and then connecting a project configured as a [proxy cache][2] to that endpoint. The documentation in Harbor is a little confusing as the page is titled `Creating Replication Endpoints` but really you are creating a registry endpoint that can be used for replication, or as a source for a caching proxy.

A pattern that is easy to understand is to name your registry endpoint and caching project the same. So, in the case of `quay.io` you will have a registry endpoint named `quay.io` and a caching proxy project called `quay.io`. To any admin going into Harbor it will be obvious how the registry endpoint is connected to the caching proxy project.

To your users this should be entirely transparent with Kyverno installed in your clusters. All external references will get transformed to use their caching proxy project analogs, and you are one step closer to not being impacted by external outages.

## Thanks

Many thanks to [@NoSkillGirl][3] and [@realshuting][4] for helping with the Kyverno setup. Kyverno is pretty great, and the people working on the project are also pretty great!

[1]: https://goharbor.io/docs/2.3.0/administration/configuring-replication/create-replication-endpoints/
[2]: https://goharbor.io/docs/2.3.0/administration/configure-proxy-cache/
[3]: https://github.com/noskillgirl
[4]: https://github.com/realshuting
