"""Rules for declaring Nomad namespaces."""

NomadNamespaceInfo = provider(
    doc = "Information about a declared Nomad namespace.",
    fields = {
        "src": "The Nomad namespace source file.",
    },
)

def _nomad_namespace_impl(ctx):
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
)
