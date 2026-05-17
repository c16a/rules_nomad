"""Rules for declaring Nomad volumes."""

NomadVolumeInfo = provider(
    doc = "Information about a declared Nomad volume.",
    fields = {
        "src": "The Nomad volume source file.",
    },
)

def _nomad_volume_impl(ctx):
    src = ctx.file.src

    return [
        DefaultInfo(files = depset([src])),
        NomadVolumeInfo(src = src),
    ]

nomad_volume = rule(
    implementation = _nomad_volume_impl,
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "A single Nomad volume file.",
        ),
    },
    doc = "Declares a single Nomad volume file.",
)
