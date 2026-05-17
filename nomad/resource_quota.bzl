"""Rules for declaring Nomad resource quotas."""

NomadResourceQuotaInfo = provider(
    doc = "Information about a declared Nomad resource quota.",
    fields = {
        "src": "The Nomad resource quota source file.",
    },
)

def _nomad_resource_quota_impl(ctx):
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
)
