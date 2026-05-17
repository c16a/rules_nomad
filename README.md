# rules_nomad

Bazel module support for HashiCorp Nomad.

This repository currently provides Bzlmod setup for downloading a Nomad release
for the current host OS/architecture, registering it as a Bazel toolchain, and
declaring Nomad configuration files.

## Usage

Add `rules_nomad` to your `MODULE.bazel`, declare the Nomad version you want,
and register the generated toolchain repository:

```starlark
bazel_dep(name = "rules_nomad", version = "0.0.0")

git_override(
    module_name = "rules_nomad",
    remote = "https://github.com/c16a/rules_nomad",
    commit = "main"
)

nomad = use_extension("@rules_nomad//nomad:extensions.bzl", "nomad")
nomad.toolchain(
    version = "2.0.1",
)
use_repo(nomad, "nomad_toolchains")

register_toolchains("@nomad_toolchains//:all")
```

Supported host platforms are:

- `darwin_amd64`
- `darwin_arm64`
- `linux_amd64`
- `linux_arm64`
- `windows_amd64`
- `windows_arm64`

The generated repository exposes:

```text
@nomad_toolchains//:nomad_binary
@nomad_toolchains//:nomad_toolchain
```

All declared Nomad resource targets are runnable with `bazel run` and use the
registered Nomad toolchain:

- `nomad_job`: `nomad job run <src>`
- `nomad_namespace`: `nomad namespace apply <src>`
- `nomad_node_pool`: `nomad node pool apply <src>`
- `nomad_resource_quota`: `nomad quota apply <src>`
- `nomad_volume`: `nomad volume create <src>`

## Environment

Set Nomad environment variables before running any Nomad-related targets:

```sh
export NOMAD_ADDR="http://127.0.0.1:4646"
```

- `NOMAD_ADDR`: URL of the Nomad server.

## Jobs

Use `nomad_job` to declare a single Nomad job file:

```starlark
load("@rules_nomad//nomad:job.bzl", "nomad_job")

nomad_job(
    name = "api",
    src = "api.nomad.hcl",
)
```

## Node Pools

Use `nomad_node_pool` to declare a single Nomad node pool file:

```starlark
load("@rules_nomad//nomad:node_pool.bzl", "nomad_node_pool")

nomad_node_pool(
    name = "batch",
    src = "batch.nomad.hcl",
)
```

## Volumes

Use `nomad_volume` to declare a single Nomad volume file:

```starlark
load("@rules_nomad//nomad:volume.bzl", "nomad_volume")

nomad_volume(
    name = "database",
    src = "database.nomad.hcl",
)
```

## Resource Quotas

`nomad_resource_quota` is only available for Nomad Enterprise users.

Use `nomad_resource_quota` to declare a single Nomad resource quota file:

```starlark
load("@rules_nomad//nomad:resource_quota.bzl", "nomad_resource_quota")

nomad_resource_quota(
    name = "production",
    src = "production-quota.nomad.hcl",
)
```

## Namespaces

Use `nomad_namespace` to declare a single Nomad namespace file:

```starlark
load("@rules_nomad//nomad:namespace.bzl", "nomad_namespace")

nomad_namespace(
    name = "platform",
    src = "platform.nomad.hcl",
)
```
