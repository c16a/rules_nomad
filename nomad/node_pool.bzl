"""Rules for declaring Nomad node pools."""

NomadNodePoolInfo = provider(
    doc = "Information about a declared Nomad node pool.",
    fields = {
        "src": "The Nomad node pool source file.",
    },
)

def _nomad_node_pool_impl(ctx):
    src = ctx.file.src
    executable = ctx.outputs.executable

    ctx.actions.write(
        output = executable,
        content = "#!/usr/bin/env bash\nexit 0\n",
        is_executable = True,
    )

    return [
        DefaultInfo(
            executable = executable,
            files = depset([src, executable]),
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
)
