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

nomad = use_extension("@rules_nomad//nomad:extensions.bzl", "nomad")
nomad.toolchain(
    version = "2.0.1",
)
use_repo(nomad, "nomad_toolchains")

register_toolchains("@nomad_toolchains//:all")
```

The `version` value is the HashiCorp Nomad release version. For example,
`version = "2.0.1"` downloads a release archive matching this pattern:

```text
https://releases.hashicorp.com/nomad/2.0.1/nomad_2.0.1_darwin_amd64.zip
```

The archive suffix is selected from the current host operating system and CPU
architecture. Supported host platforms are:

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

## Jobs

Use `nomad_job` to declare a single Nomad job file:

```starlark
load("@rules_nomad//nomad:job.bzl", "nomad_job")

nomad_job(
    name = "api",
    src = "api.nomad.hcl",
)
```

The `src` attribute accepts exactly one file.

## Node Pools

Use `nomad_node_pool` to declare a single Nomad node pool file:

```starlark
load("@rules_nomad//nomad:node_pool.bzl", "nomad_node_pool")

nomad_node_pool(
    name = "batch",
    src = "batch.nomad.hcl",
)
```

The `src` attribute accepts exactly one file.

## Namespaces

Use `nomad_namespace` to declare a single Nomad namespace file:

```starlark
load("@rules_nomad//nomad:namespace.bzl", "nomad_namespace")

nomad_namespace(
    name = "platform",
    src = "platform.nomad.hcl",
)
```

The `src` attribute accepts exactly one file.
