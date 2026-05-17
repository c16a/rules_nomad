"""Repository rule that materializes the host Nomad toolchain."""

def _host_os(repository_ctx):
    os_name = repository_ctx.os.name.lower()
    if os_name.startswith("mac os"):
        return "darwin", repository_ctx.attr.macos_constraint
    if os_name.startswith("linux"):
        return "linux", repository_ctx.attr.linux_constraint
    if os_name.startswith("windows"):
        return "windows", repository_ctx.attr.windows_constraint
    fail("Unsupported operating system for Nomad toolchain: {}".format(repository_ctx.os.name))

def _host_arch(repository_ctx):
    arch = repository_ctx.os.arch.lower()
    if arch in ["x86_64", "amd64"]:
        return "amd64", repository_ctx.attr.x86_64_constraint
    if arch in ["aarch64", "arm64"]:
        return "arm64", repository_ctx.attr.arm64_constraint
    fail("Unsupported CPU architecture for Nomad toolchain: {}".format(repository_ctx.os.arch))

def _nomad_toolchains_repo_impl(repository_ctx):
    nomad_os, os_constraint = _host_os(repository_ctx)
    nomad_arch, cpu_constraint = _host_arch(repository_ctx)
    version = repository_ctx.attr.version

    archive_name = "nomad_{version}_{os}_{arch}.zip".format(
        version = version,
        os = nomad_os,
        arch = nomad_arch,
    )
    url = "https://releases.hashicorp.com/nomad/{version}/{archive}".format(
        version = version,
        archive = archive_name,
    )

    repository_ctx.download_and_extract(
        url = url,
        output = "download",
    )

    executable = "nomad.exe" if nomad_os == "windows" else "nomad"
    repository_ctx.file(
        "BUILD.bazel",
        """
package(default_visibility = ["//visibility:public"])

load("{toolchain_bzl}", "nomad_toolchain")

filegroup(
    name = "nomad_binary",
    srcs = ["download/{executable}"],
)

nomad_toolchain(
    name = "nomad_toolchain_info",
    nomad = "download/{executable}",
)

toolchain(
    name = "nomad_toolchain",
    exec_compatible_with = [
        "{os_constraint}",
        "{cpu_constraint}",
    ],
    toolchain = ":nomad_toolchain_info",
    toolchain_type = "{toolchain_type}",
)
""".format(
            cpu_constraint = cpu_constraint,
            executable = executable,
            os_constraint = os_constraint,
            toolchain_bzl = repository_ctx.attr.toolchain_bzl,
            toolchain_type = repository_ctx.attr.toolchain_type,
        ),
    )

nomad_toolchains_repo = repository_rule(
    implementation = _nomad_toolchains_repo_impl,
    attrs = {
        "arm64_constraint": attr.label(
            default = Label("@platforms//cpu:arm64"),
        ),
        "linux_constraint": attr.label(
            default = Label("@platforms//os:linux"),
        ),
        "macos_constraint": attr.label(
            default = Label("@platforms//os:macos"),
        ),
        "toolchain_type": attr.label(
            mandatory = True,
            doc = "The rules_nomad toolchain type label.",
        ),
        "toolchain_bzl": attr.label(
            mandatory = True,
            doc = "The label of the Starlark file defining the Nomad toolchain rule.",
        ),
        "version": attr.string(
            mandatory = True,
            doc = "The HashiCorp Nomad release version to download.",
        ),
        "windows_constraint": attr.label(
            default = Label("@platforms//os:windows"),
        ),
        "x86_64_constraint": attr.label(
            default = Label("@platforms//cpu:x86_64"),
        ),
    },
    doc = "Downloads Nomad for the current host OS/architecture and exposes it as a Bazel toolchain.",
)
