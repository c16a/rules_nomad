"""Rules for declaring Nomad namespaces."""

load("//nomad:resource_quota.bzl", "NomadResourceQuotaInfo")
load("//nomad/private:runner.bzl", "write_nomad_runner")

NomadNamespaceInfo = provider(
    doc = "Information about a declared Nomad namespace.",
    fields = {
        "name": "The Bazel target name of the Nomad namespace.",
        "src": "The Nomad namespace source file.",
    },
)

def _nomad_namespace_impl(ctx):
    src = ctx.file.src
    executable, nomad = write_nomad_runner(
        ctx,
        src,
        ["namespace", "apply"],
        after_commands = [
            ["namespace", "apply", "-quota", quota[NomadResourceQuotaInfo].name, ctx.label.name]
            for quota in ctx.attr.quotas
        ],
    )

    return [
        DefaultInfo(
            executable = executable,
            files = depset([src, executable]),
            runfiles = ctx.runfiles(files = [src, nomad]),
        ),
        NomadNamespaceInfo(
            name = ctx.label.name,
            src = src,
        ),
    ]

nomad_namespace = rule(
    implementation = _nomad_namespace_impl,
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "A single Nomad namespace file.",
        ),
        "quotas": attr.label_list(
            providers = [NomadResourceQuotaInfo],
            doc = "Nomad resource quota targets to apply to this namespace.",
        ),
    },
    doc = "Declares a single Nomad namespace file.",
    executable = True,
    toolchains = ["//nomad:toolchain_type"],
)
