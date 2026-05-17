"""Rules for declaring Nomad resource quotas."""

load("//nomad/private:runner.bzl", "write_nomad_runner")

NomadResourceQuotaInfo = provider(
    doc = "Information about a declared Nomad resource quota.",
    fields = {
        "src": "The Nomad resource quota source file.",
    },
)

def _nomad_resource_quota_impl(ctx):
    src = ctx.file.src
    executable, nomad = write_nomad_runner(ctx, src, ["quota", "apply"])

    return [
        DefaultInfo(
            executable = executable,
            files = depset([src, executable]),
            runfiles = ctx.runfiles(files = [src, nomad]),
        ),
        NomadResourceQuotaInfo(src = src),
    ]

nomad_resource_quota = rule(
    implementation = _nomad_resource_quota_impl,
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "A single Nomad resource quota file.",
        ),
    },
    doc = "Declares a single Nomad resource quota file.",
    executable = True,
    toolchains = ["//nomad:toolchain_type"],
)
