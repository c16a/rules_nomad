"""Rules for declaring Nomad volumes."""

load("//nomad/private:runner.bzl", "write_nomad_runner")

NomadVolumeInfo = provider(
    doc = "Information about a declared Nomad volume.",
    fields = {
        "src": "The Nomad volume source file.",
    },
)

def _nomad_volume_impl(ctx):
    src = ctx.file.src
    executable, nomad = write_nomad_runner(ctx, src, ["volume", "create"])

    return [
        DefaultInfo(
            executable = executable,
            files = depset([src, executable]),
            runfiles = ctx.runfiles(files = [src, nomad]),
        ),
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
    executable = True,
    toolchains = ["//nomad:toolchain_type"],
)
