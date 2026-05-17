"""Toolchain support for Nomad rules."""

def _nomad_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            nomad = ctx.file.nomad,
        ),
    ]

nomad_toolchain = rule(
    implementation = _nomad_toolchain_impl,
    attrs = {
        "nomad": attr.label(
            allow_single_file = True,
            executable = True,
            cfg = "exec",
            mandatory = True,
            doc = "The Nomad executable.",
        ),
    },
    doc = "Defines a Nomad toolchain.",
)
