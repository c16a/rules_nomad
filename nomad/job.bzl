"""Rules for declaring Nomad jobs."""

NomadJobInfo = provider(
    doc = "Information about a declared Nomad job.",
    fields = {
        "src": "The Nomad job source file.",
    },
)

def _nomad_job_impl(ctx):
    src = ctx.file.src

    return [
        DefaultInfo(files = depset([src])),
        NomadJobInfo(src = src),
    ]

nomad_job = rule(
    implementation = _nomad_job_impl,
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "A single Nomad job file.",
        ),
    },
    doc = "Declares a single Nomad job file.",
)
