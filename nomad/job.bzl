"""Rules for declaring Nomad jobs."""

NomadJobInfo = provider(
    doc = "Information about a declared Nomad job.",
    fields = {
        "src": "The Nomad job source file.",
    },
)

def _nomad_job_impl(ctx):
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
    executable = True,
)
