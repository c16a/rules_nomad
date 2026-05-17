"""Rules for declaring Nomad resource quotas."""

NomadResourceQuotaInfo = provider(
    doc = "Information about a declared Nomad resource quota.",
    fields = {
        "src": "The Nomad resource quota source file.",
    },
)

def _nomad_resource_quota_impl(ctx):
    src = ctx.file.src

    return [
        DefaultInfo(files = depset([src])),
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
)
