"""Rules for declaring Nomad jobs."""

load("//nomad/private:runner.bzl", "write_nomad_runner")

NomadJobInfo = provider(
    doc = "Information about a declared Nomad job.",
    fields = {
        "src": "The Nomad job source file.",
    },
)

def _nomad_job_impl(ctx):
    src = ctx.file.src
    executable, nomad = write_nomad_runner(ctx, src, ["job", "run"])

    return [
        DefaultInfo(
            executable = executable,
            files = depset([src, executable]),
            runfiles = ctx.runfiles(files = [src, nomad]),
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
    toolchains = ["//nomad:toolchain_type"],
)
