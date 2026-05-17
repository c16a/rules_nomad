"""Module extension for registering a host Nomad toolchain."""

load("//nomad/private:toolchain_repo.bzl", "nomad_toolchains_repo")

def _nomad_impl(module_ctx):
    versions = {}

    for module in module_ctx.modules:
        for toolchain in module.tags.toolchain:
            if module.name in versions:
                fail("Only one Nomad toolchain version may be declared per module")
            versions[module.name] = toolchain.version

    root_version = versions.get(module_ctx.modules[0].name)
    if not root_version:
        fail("Declare a Nomad version with nomad.toolchain(version = \"...\")")

    nomad_toolchains_repo(
        name = "nomad_toolchains",
        version = root_version,
        toolchain_type = Label("//nomad:toolchain_type"),
    )

_toolchain_tag = tag_class(
    attrs = {
        "version": attr.string(
            mandatory = True,
            doc = "The HashiCorp Nomad release version to download, for example \"2.0.1\".",
        ),
    },
)

nomad = module_extension(
    implementation = _nomad_impl,
    tag_classes = {
        "toolchain": _toolchain_tag,
    },
)
