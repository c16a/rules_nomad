"""Rules for declaring Nomad namespaces."""

load("//nomad/private:runner.bzl", "write_nomad_runner")

NomadNamespaceInfo = provider(
    doc = "Information about a declared Nomad namespace.",
    fields = {
        "src": "The Nomad namespace source file.",
    },
)

def _nomad_namespace_impl(ctx):
    src = ctx.file.src
    executable, nomad = write_nomad_runner(ctx, src, ["namespace", "apply"])

    return [
        DefaultInfo(
            executable = executable,
            files = depset([src, executable]),
            runfiles = ctx.runfiles(files = [src, nomad]),
        ),
        NomadNamespaceInfo(src = src),
    ]

nomad_namespace = rule(
    implementation = _nomad_namespace_impl,
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "A single Nomad namespace file.",
        ),
    },
    doc = "Declares a single Nomad namespace file.",
    executable = True,
    toolchains = ["//nomad:toolchain_type"],
)
