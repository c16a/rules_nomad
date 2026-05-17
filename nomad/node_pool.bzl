"""Rules for declaring Nomad node pools."""

load("//nomad/private:runner.bzl", "write_nomad_runner")

NomadNodePoolInfo = provider(
    doc = "Information about a declared Nomad node pool.",
    fields = {
        "src": "The Nomad node pool source file.",
    },
)

def _nomad_node_pool_impl(ctx):
    src = ctx.file.src
    executable, nomad = write_nomad_runner(ctx, src, ["node", "pool", "apply"])

    return [
        DefaultInfo(
            executable = executable,
            files = depset([src, executable]),
            runfiles = ctx.runfiles(files = [src, nomad]),
        ),
        NomadNodePoolInfo(src = src),
    ]

nomad_node_pool = rule(
    implementation = _nomad_node_pool_impl,
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "A single Nomad node pool file.",
        ),
    },
    doc = "Declares a single Nomad node pool file.",
    executable = True,
    toolchains = ["//nomad:toolchain_type"],
)
